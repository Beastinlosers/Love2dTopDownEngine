return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "1.0.3",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 20,
  height = 20,
  tilewidth = 32,
  tileheight = 32,
  nextobjectid = 22,
  properties = {},
  tilesets = {
    {
      name = "TileSet",
      firstgid = 1,
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      image = "TileSet.png",
      imagewidth = 452,
      imageheight = 32,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 32,
        height = 32
      },
      properties = {},
      terrains = {},
      tilecount = 14,
      tiles = {
        {
          id = 12,
          properties = {
            ["collidable"] = "true"
          }
        }
      }
    },
    {
      name = "TileSet",
      firstgid = 15,
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      image = "TileSet.png",
      imagewidth = 452,
      imageheight = 32,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 32,
        height = 32
      },
      properties = {},
      terrains = {},
      tilecount = 14,
      tiles = {
        {
          id = 12,
          properties = {
            ["collidable"] = "true"
          }
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Floor",
      x = 0,
      y = 0,
      width = 20,
      height = 20,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
        11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
        11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
        11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
        11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
        11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
        11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
        11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
        11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
        11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
        11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
        11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
        11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
        11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
        11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
        11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
        11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
        11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
        11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
        11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11
      }
    },
    {
      type = "tilelayer",
      name = "Tile Layer 2",
      x = 0,
      y = 0,
      width = 20,
      height = 20,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {
        ["collidable"] = true
      },
      encoding = "lua",
      data = {
        13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13,
        13, 0, 0, 0, 0, 13, 0, 0, 0, 0, 0, 0, 13, 0, 0, 0, 0, 0, 0, 13,
        13, 0, 0, 0, 0, 13, 0, 0, 0, 0, 0, 0, 13, 0, 0, 0, 0, 0, 0, 13,
        13, 0, 0, 0, 0, 13, 0, 0, 0, 0, 0, 0, 13, 0, 0, 0, 0, 0, 0, 13,
        13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 0, 13, 13, 13, 13, 13, 13,
        13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13,
        13, 0, 0, 0, 0, 0, 0, 0, 0, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13,
        13, 0, 0, 0, 0, 0, 0, 0, 0, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13,
        13, 13, 13, 13, 13, 13, 0, 0, 0, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13,
        13, 0, 0, 0, 0, 0, 0, 0, 0, 13, 0, 0, 0, 0, 13, 13, 13, 13, 0, 13,
        13, 0, 0, 0, 0, 0, 0, 0, 0, 13, 0, 0, 0, 0, 13, 0, 0, 0, 0, 13,
        13, 0, 0, 0, 0, 0, 0, 0, 0, 13, 0, 0, 0, 0, 13, 0, 0, 0, 0, 13,
        13, 0, 0, 0, 0, 0, 0, 0, 0, 13, 0, 0, 0, 0, 13, 0, 0, 0, 0, 13,
        13, 0, 0, 0, 0, 0, 0, 0, 0, 13, 0, 0, 0, 0, 13, 13, 13, 13, 13, 13,
        13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13,
        13, 13, 13, 13, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13,
        13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 0, 13, 13, 13, 13,
        13, 0, 0, 0, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 0, 0, 0, 0, 13,
        13, 0, 0, 0, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 0, 0, 0, 0, 13,
        13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13
      }
    },
    {
      type = "objectgroup",
      name = "debugsens",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {
        ["collidable"] = true,
        ["sensor"] = true,
        ["userdata"] = "testsensor"
      },
      objects = {
        {
          id = 21,
          name = "toggletest",
          type = "",
          shape = "rectangle",
          x = 222,
          y = 29,
          width = 132,
          height = 87,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
