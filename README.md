# Shino

A UI kit for Phoenix LiveView.

## Installation

1. add `:shino` to the deps of `mix.exs`:

```elixir
{:shino, <requirement>}
```

2. add shino to the deps of `package.json`:

```elixir
"shino": "file:../../deps/shino",
```

3. add Tailwind config of shino to your project's `tailwind.config.js`:

```javascript
import mergeOptions from "merge-options"
import { tailwindConfig as shinoUI } from "shino/ui"

export default mergeOptions.apply({ concatArrays: true }, [
  shinoUI,
  {
    content: [
      "../../deps/shino/**/*.*ex",
      // ...
    ],
  }
]
```

4. (optional) add notification hook to Phoenix LiveView:

```javascript
import { createNotificationHook as createShinoNotificationHook } from "shino/notification"

const liveSocket = new LiveSocket("/live", Socket, {
  hooks: {
    "Shino.Notification": createShinoNotificationHook({ maxShownNotifications: 3 }),
  },
})
```
