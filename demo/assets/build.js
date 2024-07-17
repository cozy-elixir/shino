import esbuild from "esbuild"
import pluginStyle from "esbuild-style-plugin"
import postcssImport from "postcss-import"
import tailwindcss from "tailwindcss"
import autoprefixer from "autoprefixer"

const args = process.argv.slice(2)
const watch = args.includes("--watch")
const deploy = args.includes("--deploy")

const target = "es2015"
const outDir = "../priv/static/assets"

async function main() {
  const ctx = await esbuild.context({
    entryPoints: ["app.js"],
    resolveExtensions: [".js"],
    outdir: outDir,
    bundle: true,
    splitting: true,
    target: target,
    format: "esm",
    minify: deploy,
    sourcemap: deploy ? undefined : "linked",
    plugins: [
      pluginStyle({
        postcss: {
          plugins: [postcssImport, tailwindcss, autoprefixer],
        },
      }),
    ],
    loader: {
      ".ttf": "file",
      ".woff": "file",
      ".woff2": "file",
      ".eot": "file",
      ".svg": "file",
    },
  })

  if (watch) {
    await ctx.watch()

    // watch STDIN and terminate esbuild when Phoenix quits
    process.stdin.on("close", () => {
      process.exit(0)
    })

    process.stdin.resume()
  } else {
    await ctx.rebuild()
    process.exit(0)
  }
}

main()
