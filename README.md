# ComboUI

## Installation

1. add `:combo_ui` to the deps of `mix.exs`:

```elixir
{:combo_ui, <requirement>}
```

2. add combo_ui to the deps of `package.json`:

```elixir
"combo_ui": "file:../../deps/combo_ui/assets",
```

3. merge `tailwind.config.js` to your project's `tailwind.config.js`:

```javascript
import mergeOptions from "merge-options"
import configComboUI from "combo_ui/tailwind.config.js"

export default mergeOptions(configComboUI, {
  content: [
    "../../deps/combo_ui/**/*.*ex",
    // ...
  ],
})
```

4. import the theme file:

```css
@import "tailwindcss/base";
@import "tailwindcss/components";
@import "tailwindcss/utilities";

@import "combo_ui/theme.css";
```
