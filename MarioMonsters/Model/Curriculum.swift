import Foundation

/// Cambridge Movers / 4º EPO content, built from the mistakes in Mario's notebook
/// (September–October 2026): to be, have got, there is/are, can, present simple,
/// describing people, food, days and family. The rest of the Movers syllabus is in CurriculumMovers.swift.
enum Curriculum {
    static let all: [Card] = ae + noNo + jumper + snake + traps + gotLost + moversGrammar + moversVocabulary

    static func cards(for monster: MonsterID) -> [Card] {
        all.filter { $0.monster == monster }
    }

    static func card(id: String) -> Card? {
        byID[id]
    }

    private static let byID: [String: Card] = Dictionary(uniqueKeysWithValues: all.map { ($0.id, $0) })

    // MARK: - Monstruo Ae: phonetic spelling of tricky words

    static let ae: [Card] = [
        w(.ae, "I", "yo", "🙋", ["Ae", "Ai"], tip: "Suena «ai», pero se escribe solo con una letra: I. ¡Y siempre en MAYÚSCULA!"),
        w(.ae, "good", "bueno", "👍", ["god", "gud"], tip: "good lleva dos oes. God (con una) significa Dios."),
        w(.ae, "hair", "pelo", "💇", ["hear", "jer"], tip: "hair = pelo. hear = oír. ¡Suenan parecido pero son distintas!"),
        w(.ae, "straight hair", "pelo liso", "💁", ["star hair", "streit hair"], tip: "straight tiene letras que no suenan: s-t-r-a-i-g-h-t. Star es estrella ⭐."),
        w(.ae, "wavy hair", "pelo ondulado", "〰️", ["weivy hair", "endulzado hair"], tip: "wavy = ONDULADO (como las olas 🌊). ¡No es endulzado! 🍭"),
        w(.ae, "curly hair", "pelo rizado", "🌀", ["kurly hair", "corly hair"]),
        w(.ae, "blonde hair", "pelo rubio", "👱", ["blond jer", "blonde hear"]),
        w(.ae, "earrings", "pendientes", "💎", ["errancins", "irrings"], tip: "earrings: ear (oreja) + rings (anillos). ¡Anillos para la oreja!"),
        w(.ae, "necklace", "collar", "📿", ["neclake", "nekleis"], tip: "necklace: neck (cuello) + lace. ¡Algo para el cuello!"),
        w(.ae, "bracelet", "pulsera", "⌚", ["brazalet", "breislet"]),
        w(.ae, "pirate", "pirata", "🏴‍☠️", ["perit", "pairat"]),
        w(.ae, "money", "dinero", "💰", ["monay", "mani"]),
        w(.ae, "coin", "moneda", "🪙", ["coyn", "koin"]),
        w(.ae, "drum", "tambor", "🥁", ["dram", "drom"]),
        w(.ae, "blanket", "manta", "🛏️", ["blanquet", "blankit"]),
        w(.ae, "friend", "amigo / amiga", "🤝", ["frend", "freind"], tip: "friend lleva una i escondida: fr-I-end. Piensa: «fri-end»."),
        w(.ae, "English", "inglés", "🇬🇧", ["inglis", "english"], tip: "English siempre con E mayúscula: en inglés los idiomas y países van con mayúscula."),
        w(.ae, "Wednesday", "miércoles", "📅", ["Wensday", "wednesday"], tip: "Wednesday tiene una d que no suena: We-D-nes-day. Y los días van con mayúscula."),
        w(.ae, "Thursday", "jueves", "📆", ["Therday", "Tursday"]),
        w(.ae, "they", "ellos / ellas", "👫", ["dei", "Hil"], tip: "they = ellos. Se escribe t-h-e-y."),
        w(.ae, "school", "colegio", "🏫", ["schoel", "scul"]),
        w(.ae, "favourite", "favorito", "❤️", ["faborit", "favorit"], tip: "favourite (inglés británico) tiene la letra u: favo-U-rite."),
        w(.ae, "soup", "sopa", "🍲", ["sope", "sup"]),
        w(.ae, "brown", "marrón", "🟤", ["braun", "brawn"]),
        w(.ae, "freckles", "pecas", "🧑‍🦰", ["frekels", "freckels"]),
        w(.ae, "moustache", "bigote", "🥸", ["mustach", "moustach"]),
        w(.ae, "beard", "barba", "🧔", ["bird", "beerd"], tip: "beard = barba. ¡bird es pájaro 🐦!"),
        w(.ae, "eyebrows", "cejas", "🤨", ["aibraus", "eyebraws"], tip: "eyebrows: eye (ojo) + brows. Empieza por eye, como «ojo»."),
        w(.ae, "ponytail", "coleta", "🐴", ["ponitail", "poni teil"], tip: "ponytail: pony (poni) + tail (cola). ¡Cola de poni!"),
        w(.ae, "study", "estudiar", "📚", ["estudy", "estudient"], tip: "En inglés no hay e delante: study, school, Spain. ¡Nada de «es»!"),
        w(.ae, "dance", "bailar", "💃", ["dans", "bailin"]),
        w(.ae, "chess", "ajedrez", "♟️", ["ches", "chees"]),
        w(.ae, "tall", "alto", "🦒", ["tol", "tale"]),
        w(.ae, "brave", "valiente", "🦁", ["breiv", "brabe"]),
        w(.ae, "clever", "listo", "🧠", ["clevar", "klever"]),
    ]

    // MARK: - El No-No: negation with Spanish "no"

    static let noNo: [Card] = [
        s(.noNo, "I am not late.", "Yo no llego tarde.", "⏰", ["I no late.", "Ae no late."]),
        s(.noNo, "She isn't at home.", "Ella no está en casa.", "🏠", ["She is no home.", "She no at home."]),
        s(.noNo, "We aren't friends.", "Nosotros no somos amigos.", "🙅", ["We no friends.", "We is no friends."]),
        s(.noNo, "It isn't a cat.", "No es un gato.", "🐱", ["It no a cat.", "It is no cat."]),
        s(.noNo, "They aren't in the classroom.", "Ellos no están en la clase.", "🏫", ["They are no in the classroom.", "They no in classroom."]),
        s(.noNo, "He isn't tall.", "Él no es alto.", "🧍", ["He no tall.", "You no tall."]),
        s(.noNo, "I am not tall.", "Yo no soy alto.", "📏", ["Ae no tall.", "I no tall."]),
        s(.noNo, "He isn't a pirate.", "Él no es un pirata.", "🏴‍☠️", ["The boy no an perit.", "He no a pirate."]),
        s(.noNo, "I can't sing.", "Yo no puedo cantar.", "🎤", ["Ae no sing.", "I no can sing."], tip: "No puedo = can't. Nada de «no»."),
        s(.noNo, "She can't swim.", "Ella no sabe nadar.", "🏊", ["She no can swim.", "She no swim."]),
        s(.noNo, "I haven't got a pet.", "Yo no tengo mascota.", "🐶", ["Ae no pets.", "I no have pet."], tip: "No tengo = haven't got. Con he/she: hasn't got."),
        s(.noNo, "He hasn't got brown hair.", "Él no tiene el pelo marrón.", "🟤", ["He no brown hair.", "He haven't got brown hair."]),
        s(.noNo, "She hasn't got a necklace.", "Ella no tiene un collar.", "📿", ["She haven't neclake.", "She no have necklace."]),
        s(.noNo, "We haven't got a drum.", "Nosotros no tenemos un tambor.", "🥁", ["Boys haven't drum.", "We no have drum."]),
        s(.noNo, "I don't play in the park.", "Yo no juego en el parque.", "🛝", ["Ae no play in the park.", "I doesn't play in the park."], tip: "Para decir que no haces algo, usa don't. Si es él o ella, doesn't: She doesn't play."),
        s(.noNo, "She doesn't play chess on Mondays.", "Ella no juega al ajedrez los lunes.", "♟️", ["She hasen't chess Monday.", "She don't play chess on Mondays."]),
        s(.noNo, "He doesn't eat pizza on Fridays.", "Él no come pizza los viernes.", "🍕", ["He hasen't pizza the friday.", "He no eat pizza on Fridays."]),
        s(.noNo, "They don't dance at the disco.", "Ellos no bailan en la disco.", "🪩", ["Hil hasen't bailin in the desco.", "They doesn't dance at the disco."]),
        s(.noNo, "I don't like basketball.", "No me gusta el baloncesto.", "🏀", ["I no like basketball.", "No basketball is good."]),
        s(.noNo, "He doesn't study English.", "Él no estudia inglés.", "📚", ["He no study English.", "He don't study English."]),
        s(.noNo, "The bird doesn't swim.", "El pájaro no nada.", "🐦", ["The bird don't swim.", "The bird no swims."]),
    ]

    // MARK: - Verbo Saltarín: questions need inversion / do-does

    static let jumper: [Card] = [
        s(.jumper, "Are you happy?", "¿Estás contento?", "😀", ["You are happy?", "You happy?"]),
        s(.jumper, "Is she your sister?", "¿Es ella tu hermana?", "👧", ["She is your sister?", "She your sister?"]),
        s(.jumper, "Are they at school?", "¿Están ellos en el colegio?", "🏫", ["They are at school?", "They at school?"]),
        s(.jumper, "Is it a laptop?", "¿Es un portátil?", "💻", ["It is a laptop?", "It a laptop?"]),
        s(.jumper, "Are we friends?", "¿Somos amigos?", "🤝", ["We are friends?", "We friends?"]),
        s(.jumper, "Has she got red hair?", "¿Tiene ella el pelo rojo?", "👩‍🦰", ["She red hair?", "Have she got red hair?"], tip: "Pregunta con have got: el HAS salta delante y el got se queda atrás. Has she got…?"),
        s(.jumper, "Has he got violet hair?", "¿Tiene él el pelo violeta?", "💜", ["He violet hair?", "Haven't he violet hair?"]),
        s(.jumper, "Have you got curly hair?", "¿Tienes el pelo rizado?", "🌀", ["You have curly hair?", "Ae have curly hair?"]),
        s(.jumper, "Has he got a beard?", "¿Tiene él barba?", "🧔", ["He bird?", "He has got a beard?"]),
        s(.jumper, "Have you got any pets?", "¿Tienes mascotas?", "🐹", ["You have got any pets?", "You have pets?"]),
        s(.jumper, "Can you swim?", "¿Sabes nadar?", "🏊", ["You can swim?", "Do you can swim?"], tip: "Con can no necesitamos do: el can salta delante. Can you swim?"),
        s(.jumper, "Can you play chess?", "¿Sabes jugar al ajedrez?", "♟️", ["You can play chess?", "Do you can play chess?"]),
        s(.jumper, "Does she eat omelette?", "¿Come ella tortilla?", "🍳", ["She eat omelette?", "Do she eat omelette?"], tip: "Si no hay is ni can, salta Do, o Does si es él o ella. Y el verbo se queda sin s: Does she play?"),
        s(.jumper, "Do you like chocolate?", "¿Te gusta el chocolate?", "🍫", ["You like chocolate?", "Does you like chocolate?"]),
        s(.jumper, "Does she play chess on Mondays?", "¿Juega ella al ajedrez los lunes?", "♟️", ["She play chess Monday?", "Does she plays chess on Mondays?"]),
        s(.jumper, "Does he eat pizza on Fridays?", "¿Come él pizza los viernes?", "🍕", ["He eat pizza the friday?", "Do he eat pizza on Fridays?"]),
        s(.jumper, "Do they dance at the disco?", "¿Bailan ellos en la disco?", "🪩", ["They dance at the disco?", "Does they dance at the disco?"]),
        s(.jumper, "Do your friends like football?", "¿A tus amigos les gusta el fútbol?", "⚽", ["Does your friends like football?", "Your friends like football?"]),
        s(.jumper, "Does your mother eat broccoli?", "¿Come brócoli tu madre?", "🥦", ["Do your mother eat broccoli?", "Your mother eat broccoli?"]),
        s(.jumper, "Where do you live?", "¿Dónde vives?", "🏡", ["Where you live?", "Where does you live?"]),
        s(.jumper, "What time do you wake up?", "¿A qué hora te despiertas?", "⏰", ["What time you wake up?", "What time does you wake up?"]),
        s(.jumper, "Who do you live with?", "¿Con quién vives?", "👨‍👩‍👦", ["Who you live with?", "With who you live?"]),
    ]

    // MARK: - Serpiente de la S: pronouns and subject–verb agreement

    static let snake: [Card] = [
        w(.snake, "you", "tú", "👉", ["iu", "ju"]),
        w(.snake, "he", "él", "👦", ["ji", "hi"], tip: "he = él. hi es «hola» 👋."),
        w(.snake, "she", "ella", "👧", ["shi", "chi"]),
        w(.snake, "we", "nosotros", "👨‍👩‍👦", ["gui", "she"], tip: "we = nosotros. ¡Ojo! she es «ella»."),
        w(.snake, "it", "ello (cosa o animal)", "🐕", ["et", "ir"]),
        w(.snake, "has", "tiene (él / ella)", "🎒", ["haves", "hes"], tip: "have + S no es haves: con he/she se dice has."),
        w(.snake, "does", "hace (él / ella)", "🏋️", ["dos", "dose"]),
        w(.snake, "goes", "va (él / ella)", "🚶", ["gos", "gous"]),
        w(.snake, "watches", "mira (él / ella)", "📺", ["watchs", "wotches"], tip: "Si acaba en ch, sh, s, x u o, añade es: watches, washes, goes."),
        w(.snake, "studies", "estudia (él / ella)", "📖", ["studys", "estudies"], tip: "Si acaba en y, la y se cambia por ies: study, studies. Fly, flies."),
        w(.snake, "flies", "vuela (él / ella)", "🦅", ["flys", "flais"]),
        w(.snake, "buys", "compra (él / ella)", "🛒", ["buies", "beys"], tip: "Si antes de la y hay una a, una e, una o o una u, solo añades s: play, plays. Buy, buys."),
        s(.snake, "I am a student.", "Yo soy estudiante.", "🧑‍🎓", ["I is a student.", "Ae am a student."]),
        s(.snake, "He is tall.", "Él es alto.", "🦒", ["He are tall.", "He am tall."]),
        s(.snake, "She is my friend.", "Ella es mi amiga.", "👭", ["She do my friend.", "She are my friend."]),
        s(.snake, "It is a dog.", "Es un perro.", "🐕", ["It are a dog.", "It a dog."]),
        s(.snake, "You are brave.", "Tú eres valiente.", "🦁", ["You is brave.", "You es brave."]),
        s(.snake, "My best friend is María.", "Mi mejor amiga es María.", "💛", ["My bests friend es María.", "My best friend are María."]),
        s(.snake, "She has got a dog.", "Ella tiene un perro.", "🐶", ["She got a dog.", "She have got a dog."], tip: "Con he/she/it: has got. Con I/you/we/they: have got. ¡Y nunca got solo!"),
        s(.snake, "You have got a big house.", "Tú tienes una casa grande.", "🏠", ["You has got a big house.", "You got a big house."]),
        s(.snake, "He has got a red cap.", "Él tiene una gorra roja.", "🧢", ["He got a red cap.", "He have got a red cap."]),
        s(.snake, "We have got English books.", "Nosotros tenemos libros de inglés.", "📚", ["We has got English books.", "We got English books."]),
        s(.snake, "She has got curly hair.", "Ella tiene el pelo rizado.", "🌀", ["She have curly hair.", "She have got curly hair."]),
        s(.snake, "We have got coins.", "Nosotros tenemos monedas.", "🪙", ["She have money.", "We has got coins."], tip: "Nosotros = we. ¡No she!"),
        s(.snake, "She plays chess on Mondays.", "Ella juega al ajedrez los lunes.", "♟️", ["She play chess Monday.", "She play chess on Mondays."]),
        s(.snake, "He eats pizza on Fridays.", "Él come pizza los viernes.", "🍕", ["He eat pizza the friday.", "He eat pizza on Fridays."]),
        s(.snake, "She eats omelette.", "Ella come tortilla.", "🍳", ["She eat omelette.", "She eating omelette."]),
        s(.snake, "He studies English.", "Él estudia inglés.", "📖", ["He study English.", "He estudies English."]),
        s(.snake, "My sister does her homework.", "Mi hermana hace los deberes.", "✏️", ["My sister do her homework.", "My sister dos her homework."]),
        s(.snake, "They go to school by bus.", "Ellos van al colegio en autobús.", "🚌", ["They goes to school by bus.", "Hil go to school by bus."]),
        s(.snake, "He reads a book.", "Él lee un libro.", "📕", ["He reading a book.", "He read a book."], tip: "Él lee, normalmente, se dice He reads. He is reading es «está leyendo» ahora mismo."),
        s(.snake, "Tom watches TV every night.", "Tom ve la tele todas las noches.", "📺", ["Tom watch TV every night.", "Tom watchs TV every night."]),
        s(.snake, "My mother and I like pop music.", "A mi madre y a mí nos gusta la música pop.", "🎵", ["My mother and I likes pop music.", "My mother and Ae like pop music."], tip: "Mi madre y yo somos nosotros, we. ¡Así que sin s: like!"),
    ]

    // MARK: - Trampas Españolas: literal translation

    static let traps: [Card] = [
        s(.traps, "There is a ball in the school.", "Hay una pelota en el colegio.", "⚽", ["Is a ball in school.", "There is a ball in school."], tip: "Hay, si es una cosa, se dice There is. Y aquí hace falta the: in the school."),
        s(.traps, "There are two tables in the classroom.", "Hay dos mesas en la clase.", "🪑", ["Are two tables in classroom.", "There is two tables in the classroom."], tip: "Hay, si son varias cosas, se dice There are. ¡Nunca empieces solo con Are!"),
        s(.traps, "There is a monkey in the tree.", "Hay un mono en el árbol.", "🐒", ["Is a monkey in the tree.", "There are a monkey in the tree."]),
        s(.traps, "There is a boy in the class.", "Hay un niño en la clase.", "👦", ["Is a boy in class.", "There are a boy in the class."]),
        s(.traps, "There are two dogs in the park.", "Hay dos perros en el parque.", "🐕", ["Are two dogs in park.", "There is two dogs in the park."]),
        s(.traps, "She is ten years old.", "Ella tiene diez años.", "🎂", ["She has got ten years old.", "She has ten years."], tip: "¡Gran trampa! Los años NO se tienen, se SON: She IS ten years old."),
        s(.traps, "I am eight years old.", "Tengo ocho años.", "🎈", ["I have eight years.", "Ae have got eight years old."]),
        s(.traps, "He is nine years old.", "Él tiene nueve años.", "🎁", ["He has got nine years old.", "He have nine years."]),
        s(.traps, "I am playing in the park.", "Estoy jugando en el parque.", "🛝", ["I am playing in park.", "Ae am playin in the park."], tip: "En el parque = in THE park. En inglés el the también hace falta."),
        s(.traps, "He is reading a book.", "Él está leyendo un libro.", "📖", ["He reading a book.", "He is read a book."], tip: "Está haciendo algo se dice con is y el verbo con ing. ¡No te olvides del is!"),
        s(.traps, "I study English on Wednesdays.", "Estudio inglés los miércoles.", "📅", ["Ae estudient inglis the therday.", "I study English the Wednesday."], tip: "Los miércoles = on Wednesdays (on + día + s). Nada de the."),
        s(.traps, "We play football on Saturdays.", "Jugamos al fútbol los sábados.", "⚽", ["We play football the Saturday.", "We play the football on Saturdays."]),
        s(.traps, "My favourite food is soup.", "Mi comida favorita es la sopa.", "🍲", ["My favourite food is the soup.", "My food favourite is soup."], tip: "En inglés favourite va ANTES de food. Y sin the: is soup."),
        s(.traps, "I have got blonde hair.", "Tengo el pelo rubio.", "👱", ["I have got hair blonde.", "I have the hair blonde."], tip: "El color va ANTES de la cosa: blonde hair, red cap, big house."),
        s(.traps, "She has got wavy hair.", "Ella tiene el pelo ondulado.", "〰️", ["She has got the hair wavy.", "She have hair endulzado."]),
        s(.traps, "He has got straight hair.", "Él tiene el pelo liso.", "💁", ["He have star hair.", "He has got the hair straight."]),
        s(.traps, "I like eating fish.", "Me gusta comer pescado.", "🐟", ["Me like eating fish.", "I like eat fish."], tip: "Me gusta = I like (yo gusto). Y después: eating, playing…"),
        s(.traps, "I love playing football.", "Me encanta jugar al fútbol.", "⚽", ["I love play football.", "Ae love football play."]),
        s(.traps, "My best friend is very clever.", "Mi mejor amiga es muy lista.", "🧠", ["My friend best is very clever.", "My best friend es very clever."]),
        s(.traps, "I am from Spain.", "Soy de España.", "🇪🇸", ["I am of Spain.", "I am from spain."], tip: "Ser de un país se dice be from: I am from Spain. ¡Y Spain con mayúscula!"),
        s(.traps, "I live with my mum and dad.", "Vivo con mi mamá y mi papá.", "👨‍👩‍👦", ["I live with mum and dad.", "Ae live with my mum and dad."]),
    ]

    // MARK: - Builders

    static func w(_ monster: MonsterID, _ english: String, _ spanish: String, _ emoji: String, _ wrong: [String], tip: String? = nil) -> Card {
        Card(monster: monster, kind: .word, english: english, spanish: spanish, emoji: emoji, wrong: wrong, tip: tip)
    }

    static func s(_ monster: MonsterID, _ english: String, _ spanish: String, _ emoji: String, _ wrong: [String], tip: String? = nil) -> Card {
        Card(monster: monster, kind: .sentence, english: english, spanish: spanish, emoji: emoji, wrong: wrong, tip: tip)
    }
}
