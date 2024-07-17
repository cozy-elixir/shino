# Shino

## Installation

1. add `:shino` to the deps of `mix.exs`:

```elixir
{:shino, <requirement>}
```

2. add shino to the deps of `package.json`:

```elixir
"shino": "file:../../deps/shino/assets",
```

3. merge `tailwind.config.js` to your project's `tailwind.config.js`:

```javascript
import mergeOptions from "merge-options"
import configShino.UI from "shino/tailwind.config.js"

export default mergeOptions(configShino.UI, {
  content: [
    "../../deps/shino/**/*.*ex",
    // ...
  ],
})
```

4. import the theme file:

```css
@import "tailwindcss/base";
@import "tailwindcss/components";
@import "tailwindcss/utilities";

@import "shino/theme.css";
```
