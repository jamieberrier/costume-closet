# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
DanceStudio.destroy_all
Dancer.destroy_all
Costume.destroy_all
CostumeAssignment.destroy_all

# DANCE STUDIOS
toc = DanceStudio.create(studio_name: 'Touch of Class', owner_name: 'Linda Bush', email: 'owner@toc.com', password: 'test', password_confirmation: 'test')
ci = DanceStudio.create(studio_name: 'Classic Image', owner_name: 'Devin Moss', email: 'owner@ci.com', password: 'test', password_confirmation: 'test')

# DANCERS
## toc
maddie = Dancer.create(first_name: 'Madelyn', last_name: 'Berrier', email: 'maddie@toc.com', current_dancer: 1, dance_studio_id: toc.id, password: 'test', password_confirmation: 'test')
fifi = Dancer.create(first_name: 'Sophia', last_name: 'Kessler', email: 'fifi@toc.com', current_dancer: 1, dance_studio_id: toc.id, password: 'test', password_confirmation: 'test')
ainsley = Dancer.create(first_name: 'Ainsley', last_name: 'McKlees', email: 'ainsley@toc.com', current_dancer: 1, dance_studio_id: toc.id, password: 'test', password_confirmation: 'test')

mia = Dancer.create(first_name: 'Mia', last_name: 'Tomiselli', email: 'mia@toc.com', current_dancer: 1, dance_studio_id: toc.id, password: 'test', password_confirmation: 'test')
tori = Dancer.create(first_name: 'Tori', last_name: 'Taylor', email: 'tori@toc.com', current_dancer: 1, dance_studio_id: toc.id, password: 'test', password_confirmation: 'test')
zoey = Dancer.create(first_name: 'Zoey', last_name: 'Smith', email: 'zoey@toc.com', current_dancer: 0, dance_studio_id: toc.id, password: 'test', password_confirmation: 'test')

## ci
suzy = Dancer.create(first_name: 'Suzy', last_name: 'Smith', email: 'suzy@ci.com', current_dancer: 1, dance_studio_id: ci.id, password: 'test', password_confirmation: 'test')
polly = Dancer.create(first_name: 'Polly', last_name: 'Pocket', email: 'maddie@ci.com', current_dancer: 1, dance_studio_id: ci.id, password: 'test', password_confirmation: 'test')
tina = Dancer.create(first_name: 'Tina', last_name: 'Twerk', email: 'maddie@ci.com', current_dancer: 1, dance_studio_id: ci.id, password: 'test', password_confirmation: 'test')

# COSTUMES
## toc
blue = Costume.create(top_description: 'blue sequin puffy sleeved top', bottoms_description: 'blue sequin poofy skirt', picture: 'https://cdn1.discountdance.net/image/395x526/n7307c_1.jpg', dance_studio_id: toc.id)
red = Costume.create(top_description: 'black sequin top, red sequin jacket', bottoms_description: 'black bussel shorts', picture: 'https://dqaecz4y0qq82.cloudfront.net/products/sq11469.jpg?preset=hero&404=y', dance_studio_id: toc.id)
green = Costume.create(onepiece_description: 'sea foam green lace, one-shoulder, dress', picture: 'https://i.pinimg.com/originals/53/4c/ef/534cef292ac66ffdc410290707634bce.jpg', dance_studio_id: toc.id)
teal = Costume.create(onepiece_description: 'light teal tutu', picture: 'https://assets.costumegallery.net/media/CACHE/images/product_images/19544-014-1/50ef5b559e64328453e6322c958c5ad6.jpg', dance_studio_id: toc.id)
purple = Costume.create(onepiece_description: 'purple mesh wrap dress', picture: 'https://dqaecz4y0qq82.cloudfront.net/products/d8423_wisteria.jpg?preset=hero', dance_studio_id: toc.id)

## ci
pink = Costume.create(top_description: 'pink sequin puffy sleeved top', bottoms_description: 'pink sequin poofy skirt', picture: 'https://dqaecz4y0qq82.cloudfront.net/products/sq9601.jpg?preset=hero&404=y', dance_studio_id: ci.id)
white = Costume.create(top_description: 'black sequin top, white sequin jacket', bottoms_description: 'black bussel shorts', picture: 'https://i.pinimg.com/originals/36/49/d8/3649d8e461a0a2f07f3bfb49b7f78494.jpg', dance_studio_id: ci.id)
yellow = Costume.create(onepiece_description: 'yellow lace, one-shoulder, dress', picture: 'https://i.pinimg.com/originals/c8/13/78/c81378a8f16ad1aff716913a2167ebdb.jpg', dance_studio_id: ci.id)

# COSTUME ASSIGNMENTS
## toc
CostumeAssignment.create(dancer_id: maddie.id, costume_id: blue.id, hair_accessory: 'blue tear drop hat', costume_size: 'S', song_name: 'Blue Suede Shoes', costume_condition: 'New', dance_season: '2019', genre: 'tap', shoe: 'blue sequin tap', tight: 'tan footed')
CostumeAssignment.create(dancer_id: fifi.id, costume_id: blue.id, hair_accessory: 'blue tear drop hat', costume_size: 'S', song_name: 'Blue Suede Shoes', costume_condition: 'New', dance_season: '2019', genre: 'tap', shoe: 'blue sequin tap', tight: 'tan footed')
CostumeAssignment.create(dancer_id: ainsley.id, costume_id: blue.id, hair_accessory: 'blue tear drop hat', costume_size: 'S', song_name: 'Blue Suede Shoes', costume_condition: 'New', dance_season: '2019', genre: 'tap', shoe: 'blue sequin tap', tight: 'tan footed')

CostumeAssignment.create(dancer_id: maddie.id, costume_id: blue.id, hair_accessory: 'blue sequin bow', costume_size: 'S', song_name: 'Rip It Up', costume_condition: 'Used', dance_season: '2020', genre: 'tap', shoe: 'blue sequin tap', tight: 'tan footed')
CostumeAssignment.create(dancer_id: fifi.id, costume_id: blue.id, hair_accessory: 'blue sequin bow', costume_size: 'S', song_name: 'Rip It Up', costume_condition: 'Used', dance_season: '2020', genre: 'tap', shoe: 'blue sequin tap', tight: 'tan footed')
CostumeAssignment.create(dancer_id: ainsley.id, costume_id: blue.id, hair_accessory: 'blue sequin bow', costume_size: 'S', song_name: 'Rip It Up', costume_condition: 'Used', dance_season: '2020', genre: 'tap', shoe: 'blue sequin tap', tight: 'tan footed')

CostumeAssignment.create(dancer_id: maddie.id, costume_id: red.id, hair_accessory: 'red sequin bow', costume_size: 'S', song_name: 'Sophisticated Ladies', costume_condition: 'New', dance_season: '2020', genre: 'hip hop', shoe: 'red high top converse', tight: 'none')
CostumeAssignment.create(dancer_id: fifi.id, costume_id: red.id, hair_accessory: 'red sequin bow', costume_size: 'S', song_name: 'Sophisticated Ladies', costume_condition: 'New', dance_season: '2020', genre: 'hip hop', shoe: 'red high top converse', tight: 'none')
CostumeAssignment.create(dancer_id: ainsley.id, costume_id: red.id, hair_accessory: 'red sequin bow', costume_size: 'S', song_name: 'Sophisticated Ladies', costume_condition: 'New', dance_season: '2020', genre: 'hip hop', shoe: 'red high top converse', tight: 'none')

CostumeAssignment.create(dancer_id: tori.id, costume_id: green.id, hair_accessory: 'none', costume_size: 'S', song_name: 'Wonder', costume_condition: 'New', dance_season: '2019', genre: 'lyrical', shoe: 'tan half sole', tight: 'none')
CostumeAssignment.create(dancer_id: mia.id, costume_id: green.id, hair_accessory: 'none', costume_size: 'S', song_name: 'Wonder', costume_condition: 'New', dance_season: '2019', genre: 'lyrical', shoe: 'tan half sole', tight: 'none')
CostumeAssignment.create(dancer_id: zoey.id, costume_id: green.id, hair_accessory: 'none', costume_size: 'S', song_name: 'Wonder', costume_condition: 'New', dance_season: '2019', genre: 'lyrical', shoe: 'tan half sole', tight: 'none')

CostumeAssignment.create(dancer_id: maddie.id, costume_id: green.id, hair_accessory: 'none', costume_size: 'S', song_name: 'Imagine', costume_condition: 'Used', dance_season: '2020', genre: 'lyrical', shoe: 'tan half sole', tight: 'none')
CostumeAssignment.create(dancer_id: fifi.id, costume_id: green.id, hair_accessory: 'none', costume_size: 'S', song_name: 'Imagine', costume_condition: 'Used', dance_season: '2020', genre: 'lyrical', shoe: 'tan half sole', tight: 'none')
CostumeAssignment.create(dancer_id: ainsley.id, costume_id: green.id, hair_accessory: 'none', costume_size: 'S', song_name: 'Imagine', costume_condition: 'Used', dance_season: '2020', genre: 'lyrical', shoe: 'tan half sole', tight: 'none')
# Currently Unassigned
CostumeAssignment.create(dancer_id: zoey.id, costume_id: teal.id, hair_accessory: 'tiara', costume_size: 'M', song_name: 'Ice Queen', costume_condition: 'New', dance_season: '2019', genre: 'ballet', shoe: 'pink ballet', tight: 'pink footed')
CostumeAssignment.create(dancer_id: tori.id, costume_id: purple.id, hair_accessory: 'none', costume_size: 'M', song_name: 'Whisper', costume_condition: 'New', dance_season: '2018', genre: 'contemporary', shoe: 'none', tight: 'none')
CostumeAssignment.create(dancer_id: mia.id, costume_id: purple.id, hair_accessory: 'none', costume_size: 'M', song_name: 'Whisper', costume_condition: 'New', dance_season: '2018', genre: 'contemporary', shoe: 'none', tight: 'none')
CostumeAssignment.create(dancer_id: zoey.id, costume_id: purple.id, hair_accessory: 'none', costume_size: 'M', song_name: 'Whisper', costume_condition: 'New', dance_season: '2018', genre: 'contemporary', shoe: 'none', tight: 'none')
CostumeAssignment.create(dancer_id: maddie.id, costume_id: purple.id, hair_accessory: 'none', costume_size: 'S', song_name: 'Whisper', costume_condition: 'New', dance_season: '2018', genre: 'contemporary', shoe: 'none', tight: 'none')
CostumeAssignment.create(dancer_id: fifi.id, costume_id: purple.id, hair_accessory: 'none', costume_size: 'S', song_name: 'Whisper', costume_condition: 'New', dance_season: '2018', genre: 'contemporary', shoe: 'none', tight: 'none')
CostumeAssignment.create(dancer_id: ainsley.id, costume_id: purple.id, hair_accessory: 'none', costume_size: 'S', song_name: 'Whisper', costume_condition: 'New', dance_season: '2018', genre: 'contemporary', shoe: 'none', tight: 'none')

## ci
CostumeAssignment.create(dancer_id: suzy.id, costume_id: pink.id, hair_accessory: 'pink tear drop hat', costume_size: 'S', song_name: 'Trouble', costume_condition: 'New', dance_season: '2020', genre: 'tap', shoe: 'tan buckle tap', tight: 'tan footed')
CostumeAssignment.create(dancer_id: polly.id, costume_id: white.id, hair_accessory: 'white sequin bow', costume_size: 'M', song_name: 'Snow', costume_condition: 'New', dance_season: '2020', genre: 'jazz', shoe: 'tan jazz', tight: 'tan fishnet')
CostumeAssignment.create(dancer_id: tina.id, costume_id: yellow.id, hair_accessory: 'yellow bow', costume_size: 'S', song_name: 'Walking On Sunshine', costume_condition: 'New', dance_season: '2019', genre: 'lyrical', shoe: 'tan half sole', tight: 'none')
