import esbuild from "esbuild"

const args = process.argv.slice(2)
const watch = args.includes("--watch")
const deploy = args.includes("--deploy")

const target = "es2015"
const outDir = "../priv/static"

async function main() {
  const ctx = await esbuild.context({
    entryPoints: ["./ui", "./notification"],
    outdir: outDir,
    bundle: true,
    target: target,
    format: "esm",
    minify: deploy,
    sourcemap: deploy ? undefined : "linked",
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
