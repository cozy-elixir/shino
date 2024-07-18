// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

import plugin from "tailwindcss/plugin.js"
import tailwindcssForms from "@tailwindcss/forms"
import tailwindcssTypography from "@tailwindcss/typography"
import { tailwindConfig as shinoUI } from "shino/ui"
import mergeOptions from "merge-options"

export default mergeOptions.apply({ concatArrays: true }, [
  shinoUI,
  {
    content: [
      "./js/**/*.js",
      "../lib/*_web.ex",
      "../lib/*_web/**/*.*ex",
      "../../lib/**/*.*ex",
      "../../assets/**/*.js",
    ],
    theme: {
      extend: {},
    },
    plugins: [
      tailwindcssTypography({ target: "legacy" }),
      tailwindcssForms,
      plugin(({ addVariant }) => {
        addVariant("phx-no-feedback", ["&.phx-no-feedback", ".phx-no-feedback &"])
        addVariant("phx-click-loading", ["&.phx-click-loading", ".phx-click-loading &"])
        addVariant("phx-submit-loading", ["&.phx-submit-loading", ".phx-submit-loading &"])
        addVariant("phx-change-loading", ["&.phx-change-loading", ".phx-change-loading &"])
      }),
    ],
  },
])
