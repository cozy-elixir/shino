# Shino

A UI kit for Phoenix.

## Notes

DON'T USE IT.

This package is still in its early stages, so it may still undergo significant changes, potentially leading to breaking changes.

## Installation

1. add `:shino` to the deps of `mix.exs`:

```elixir
{:shino, <requirement>}
```

2. add shino to the deps of `package.json`:

```json
"shino": "file:../deps/shino"
```

3. setup Tailwind config for `Shino.UI`:

```javascript
// edit tailwind.config.js
import mergeOptions from "merge-options"
import { tailwindConfig as configShinoUI } from "shino/ui"

export default mergeOptions.apply({ concatArrays: true }, [
  configShinoUI,
  {
    content: [
      "../deps/shino/**/*.*ex",
      // ...
    ],
    // ...
  }
]
```

4. setup hook for `Shino.Notification`:

```javascript
import { createNotificationHook as createShinoNotificationHook } from "shino/notification"

const liveSocket = new LiveSocket("/live", Socket, {
  // ...
  hooks: {
    "Shino.Notification": createShinoNotificationHook({ maxShownNotifications: 3 }),
    // ...
  },
})
```

## Usage

For more information, see the [documentation](https://hexdocs.pm/shino).

## License

[Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0)
