import esbuild from "esbuild"

const args = process.argv.slice(2)
const watch = args.includes("--watch")
const deploy = args.includes("--deploy")

const target = "es2015"
const outDir = "../priv/static"

async function main() {
  const esm = await esbuild.context({
    entryPoints: ["./ui", "./notification"],
    outdir: outDir,
    outExtension: { ".js": ".mjs" },
    bundle: true,
    target: target,
    format: "esm",
    minify: deploy,
    sourcemap: deploy ? "external" : "inline",
  })

  const cjs = await esbuild.context({
    entryPoints: ["./ui", "./notification"],
    outdir: outDir,
    outExtension: { ".js": ".cjs" },
    bundle: true,
    target: target,
    format: "esm",
    minify: deploy,
    sourcemap: deploy ? "external" : "inline",
  })

  if (watch) {
    await [esm.watch(), cjs.watch()]

    // watch STDIN and terminate esbuild when Phoenix quits
    process.stdin.on("close", () => {
      process.exit(0)
    })

    process.stdin.resume()
  } else {
    await [esm.rebuild(), cjs.watch()]
    process.exit(0)
  }
}

main()
