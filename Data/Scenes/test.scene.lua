return {
    name = "test",
    gameObjects = {
        {
            name = "drawSceneHirearchy",
            transform = {
                position = {
                    x = 69, 
                    y = 90
                }
            },
            components = {
                {
                    classpath = "Scripts.drawSceneHierarchy"
                }
            },
            children = {
                {
                    --TODO: load a prefab if stumble at ref
                    ref="test"
                }
            }
        }
    }
}