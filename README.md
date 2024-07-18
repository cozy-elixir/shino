# Shino

A UI kit for Phoenix LiveView.

## Installation

1. add `:shino` to the deps of `mix.exs`:

```elixir
{:shino, <requirement>}
```

2. add shino to the deps of `package.json`:

```json
"shino": "file:../../deps/shino"
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

4. (optional) add notification hook of shino to Phoenix LiveView:

```javascript
import { createNotificationHook as createShinoNotificationHook } from "shino/notification"

const liveSocket = new LiveSocket("/live", Socket, {
  hooks: {
    "Shino.Notification": createShinoNotificationHook({ maxShownNotifications: 3 }),
  },
})
```

## Usage

For more information, see the [documentation](https://hexdocs.pm/shino).

## License

[Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0)
