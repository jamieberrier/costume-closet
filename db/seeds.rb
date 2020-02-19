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
toc = DanceStudio.create(studio_name: 'Touch of Class', owner_name: 'Linda Bush', email: 'owner@toc.com', password: 'test')
ci = DanceStudio.create(studio_name: 'Classic Image', owner_name: 'Devin Moss', email: 'owner@ci.com', password: 'test')

# DANCERS
## toc
maddie = Dancer.create(first_name: 'Madelyn', last_name: 'Berrier', birthdate: '09/07/2013', email: 'maddie@toc.com', phone_number: '619-555-5555', current_dancer: 1, dance_studio_id: toc.id)
fifi = Dancer.create(first_name: 'Sophia', last_name: 'Kessler', birthdate: '04/01/2013', email: 'fifi@toc.com', phone_number: '619-555-5556', current_dancer: 1, dance_studio_id: toc.id)
ainsley = Dancer.create(first_name: 'Ainsley', last_name: 'McKlees', birthdate: '01/06/2013', email: 'ainsley@toc.com', phone_number: '619-555-5557', current_dancer: 1, dance_studio_id: toc.id)

mia = Dancer.create(first_name: 'Mia', last_name: 'Tomiselli', birthdate: '01/06/2010', email: 'mia@toc.com', phone_number: '619-555-5558', current_dancer: 1, dance_studio_id: toc.id)
tori = Dancer.create(first_name: 'Tori', last_name: 'Taylor', birthdate: '10/09/2010', email: 'tori@toc.com', phone_number: '619-555-5559', current_dancer: 1, dance_studio_id: toc.id)
zoey = Dancer.create(first_name: 'Zoey', last_name: 'Smith', birthdate: '17/01/2010', email: 'zoey@toc.com', phone_number: '619-555-5550', current_dancer: 0, dance_studio_id: toc.id)

## ci
suzy = Dancer.create(first_name: 'Suzy', last_name: 'Smith', birthdate: '09/07/2008', email: 'suzy@ci.com', phone_number: '619-555-5555', current_dancer: 1, dance_studio_id: ci.id)
polly = Dancer.create(first_name: 'Polly', last_name: 'Pocket', birthdate: '09/01/2013', email: 'maddie@ci.com', phone_number: '619-555-5555', current_dancer: 1, dance_studio_id: ci.id)
tina = Dancer.create(first_name: 'Tina', last_name: 'Twerk', birthdate: '09/05/2009', email: 'maddie@ci.com', phone_number: '619-555-5555', current_dancer: 1, dance_studio_id: ci.id)

# COSTUMES
## toc
blue = Costume.create(top_description: 'blue sequin puffy sleeved top', bottoms_description: 'blue sequin poofy skirt', picture: 'image1_url', hair_accessory: 'blue tear drop hat', dance_studio_id: toc.id)
red = Costume.create(top_description: 'black sequin top, red sequin jacket', bottoms_description: 'black bussel shorts', picture: 'image2_url', hair_accessory: 'red sequin bow', dance_studio_id: toc.id)
green = Costume.create(onepiece_description: 'sea foam green lace, one-shoulder, dress', picture: 'image3_url', hair_accessory: 'none', dance_studio_id: toc.id)

## ci
pink = Costume.create(top_description: 'pink sequin puffy sleeved top', bottoms_description: 'pink sequin poofy skirt', picture: 'image4_url', hair_accessory: 'pink tear drop hat', dance_studio_id: ci.id)
white = Costume.create(top_description: 'black sequin top, white sequin jacket', bottoms_description: 'black bussel shorts', picture: 'image5_url', hair_accessory: 'white sequin bow', dance_studio_id: ci.id)
yellow = Costume.create(onepiece_description: 'yellow green lace, one-shoulder, dress', picture: 'image6_url', hair_accessory: 'yellow bow', dance_studio_id: ci.id)

# COSTUME ASSIGNMENTS
## toc
CostumeAssignment.create(dancer_id: maddie.id, costume_id: blue.id, costume_size: 'S', song_name: 'Blue Suede Shoes', costume_condition: 'new', dance_season: '2020', genre: 'tap', shoe: 'blue sequin tap', tight: 'tan footed')
CostumeAssignment.create(dancer_id: fifi.id, costume_id: blue.id, costume_size: 'S', song_name: 'Blue Suede Shoes', costume_condition: 'new', dance_season: '2020', genre: 'tap', shoe: 'blue sequin tap', tight: 'tan footed')
CostumeAssignment.create(dancer_id: ainsley.id, costume_id: blue.id, costume_size: 'S', song_name: 'Blue Suede Shoes', costume_condition: 'new', dance_season: '2020', genre: 'tap', shoe: 'blue sequin tap', tight: 'tan footed')

CostumeAssignment.create(dancer_id: maddie.id, costume_id: red.id, costume_size: 'S', song_name: 'Sophisticated Ladies', costume_condition: 'new', dance_season: '2020', genre: 'hip hop', shoe: 'red high top converse', tight: 'none')
CostumeAssignment.create(dancer_id: fifi.id, costume_id: red.id, costume_size: 'S', song_name: 'Sophisticated Ladies', costume_condition: 'new', dance_season: '2020', genre: 'hip hop', shoe: 'red high top converse', tight: 'none')
CostumeAssignment.create(dancer_id: ainsley.id, costume_id: red.id, costume_size: 'S', song_name: 'Sophisticated Ladies', costume_condition: 'new', dance_season: '2020', genre: 'hip hop', shoe: 'red high top converse', tight: 'none')

CostumeAssignment.create(dancer_id: tori.id, costume_id: green.id, costume_size: 'S', song_name: 'Wonder', costume_condition: 'new', dance_season: '2019', genre: 'lyrical', shoe: 'tan half sole', tight: 'none')
CostumeAssignment.create(dancer_id: mia.id, costume_id: green.id, costume_size: 'S', song_name: 'Wonder', costume_condition: 'new', dance_season: '2019', genre: 'lyrical', shoe: 'tan half sole', tight: 'none')
CostumeAssignment.create(dancer_id: zoey.id, costume_id: green.id, costume_size: 'S', song_name: 'Wonder', costume_condition: 'new', dance_season: '2019', genre: 'lyrical', shoe: 'tan half sole', tight: 'none')

CostumeAssignment.create(dancer_id: maddie.id, costume_id: green.id, costume_size: 'S', song_name: 'Imagine', costume_condition: 'used', dance_season: '2020', genre: 'lyrical', shoe: 'tan half sole', tight: 'none')
CostumeAssignment.create(dancer_id: fifi.id, costume_id: green.id, costume_size: 'S', song_name: 'Imagine', costume_condition: 'used', dance_season: '2020', genre: 'lyrical', shoe: 'tan half sole', tight: 'none')
CostumeAssignment.create(dancer_id: ainsley.id, costume_id: green.id, costume_size: 'S', song_name: 'Imagine', costume_condition: 'used', dance_season: '2020', genre: 'lyrical', shoe: 'tan half sole', tight: 'none')

## ci
CostumeAssignment.create(dancer_id: suzy.id, costume_id: pink.id, costume_size: 'S', song_name: 'Trouble', costume_condition: 'new', dance_season: '2020', genre: 'tap', shoe: 'tan buckle tap', tight: 'tan footed')
CostumeAssignment.create(dancer_id: polly.id, costume_id: white.id, costume_size: 'M', song_name: 'Snow', costume_condition: 'new', dance_season: '2020', genre: 'jazz', shoe: 'tan jazz', tight: 'tan fishnet')
CostumeAssignment.create(dancer_id: tina.id, costume_id: yellow.id, costume_size: 'S', song_name: 'Walking On Sunshine', costume_condition: 'new', dance_season: '2019', genre: 'lyrical', shoe: 'tan half sole', tight: 'none')
