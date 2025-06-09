-- rust-tools.lua or similar file
return {
    'mrcjkb/rustaceanvim',
    version = '^6', -- Ensure you're using the correct version
    lazy = false,
    ["rust-analyzer"] = {
        cargo = {
            allFeatures = true,
        },
    },
    config = function()
    end
}
