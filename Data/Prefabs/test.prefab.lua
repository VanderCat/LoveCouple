return {
    name = "meta",
    transform = {
        position = {
            x = 0, 
            y = 0
        },
        scale = {
            x = 1,
            y = 1
        },
        rotation = 0
    },
    components = {
        {
            classpath = "Scripts.drawDebugInfo"
        },
        {
            classpath = "Scripts.testMetaComponent",
            text = "hehe i can change this too"
        }
    },
    children = {
        {
            name = "funny game object",
            components = {}
        }
    }
}