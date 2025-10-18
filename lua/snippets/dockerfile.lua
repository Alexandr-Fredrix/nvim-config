local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

return {
    s("userdocker", {
        t({
            "RUN groupadd -g 1001 app || true \\",
            " && useradd -u 1001 -g 1001 -m -s /bin/bash app || true \\",
            " && chown -R 1001:1001 /app",
        }),
    }),
}
