extends TextureRect
var imageTexture = ImageTexture.new()
var dynImage = Image.new()


# Called when the node enters the scene tree for the first time.
func _ready():

	dynImage.create(256,256,false,Image.FORMAT_RGB8)
	dynImage.fill(Color(1,0,0,1))
	
	imageTexture.create_from_image(dynImage)
	self.texture = imageTexture
	
	imageTexture.resource_name = "The created texture!"
	print(self.texture.resource_name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	dynImage.fill(Color(randf(),0,0,1))
	imageTexture.create_from_image(dynImage)
	self.texture = imageTexture

