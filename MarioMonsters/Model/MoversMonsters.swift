import Foundation

/// The monsters added for the rest of the Cambridge Movers syllabus: "have got" (a typical error)
/// plus grammar and vocabulary topics. The five original monsters are described in Content.swift.
extension MonsterID {
    var moversInfo: MonsterInfo {
        switch self {
        case .gotLost:
            MonsterInfo(
                name: "El Got Perdido",
                tagline: "Se lleva el got de have got.",
                lesson: "Para decir que tienes algo, como una mascota, el pelo rizado o un hermano, se dice have got o has got. ¡Que no se pierda el got! Have you got a dog? I haven't got a cat. Solo se va en las respuestas cortas: Yes, I have.",
                emblem: "got",
                taunts: ["¡Me llevo tu got! Jejeje", "¡Have a secas, que es más corto!", "¡Got, got… ¿dónde está tu got?"],
                hits: ["¡Ay! ¡No has perdido el got!", "¡Nooo! ¡Have got completo!", "¡Grrr! ¡Has encontrado el got!"]
            )
        case .mixer:
            MonsterInfo(
                name: "El Revoltijo",
                tagline: "Desordena las palabras de la frase.",
                lesson: "En inglés, cómo es la cosa va delante: a red car, un coche rojo. Primero el tamaño y luego el color: a big black cat. Always y never van antes de lo que haces: I always walk. ¡Pero detrás de is! He is never late.",
                taunts: ["¡Lo pongo todo patas arriba!", "¡Como en español, que da igual!", "¡Revuelve, revuelve! Jejeje"],
                hits: ["¡Ay! ¡Cada palabra en su sitio!", "¡Nooo! ¡Me has ordenado!", "¡Grrr! ¡Qué orden más inglés!"]
            )
        case .yesterday:
            MonsterInfo(
                name: "Reloj del Ayer",
                tagline: "Se olvida de poner el verbo en pasado.",
                lesson: "Si ya pasó, como yesterday o last week, el verbo cambia. Muchos añaden ed: play, played. Otros son rebeldes y hay que aprendérselos: go, went. See, saw. Eat, ate. Con didn't y con Did, el verbo vuelve a ser normal: I didn't go. Did you see it?",
                taunts: ["¡Tic tac! ¡Ayer es igual que hoy!", "¡Goed, eated! Jejeje", "¡El pasado no existe!"],
                hits: ["¡Ay! ¡Ese pasado está perfecto!", "¡Nooo! ¡Te sabes los rebeldes!", "¡Tic… tac… me paro!"]
            )
        case .bigger:
            MonsterInfo(
                name: "Gigante Comparón",
                tagline: "Lía los comparativos y superlativos.",
                lesson: "Con palabras cortas añade er para comparar: big, bigger. Y est para el que más: the biggest. Con palabras largas se usa more y the most: more beautiful. Hay rebeldes: good, better, the best. ¡Y «que» se dice than!",
                taunts: ["¡Soy más big que tú!", "¡The most good! Jejeje", "¡Gooder, badder!"],
                hits: ["¡Ay! ¡Eres el mejor comparando!", "¡Nooo! ¡Better, no gooder!", "¡Me has hecho más pequeño!"]
            )
        case .nowNow:
            MonsterInfo(
                name: "Monstruo Ahora-Mismo",
                tagline: "Se come el is / are de las frases con -ing.",
                lesson: "Para lo que está pasando ahora mismo se usa is o are, y el verbo con ing: She is running. ¡Que no se te olvide el is! Lo que haces todos los días va sin ing: I go to school every day.",
                taunts: ["¡Ñam! ¡Me como tu is!", "¡She running, y ya está!", "¡Ahora mismo te engaño!"],
                hits: ["¡Ay! ¡Is + ing, perfecto!", "¡Nooo! ¡Has guardado el is!", "¡Ahora mismo me duele!"]
            )
        case .octopus:
            MonsterInfo(
                name: "Pulpo Preposiciones",
                tagline: "Pone cada cosa en el sitio equivocado.",
                lesson: "¿Dónde está? In es dentro, on es encima, under es debajo, behind es detrás, next to es al lado y between es entre. ¿Cuándo? At para la hora: at seven o'clock. On para el día: on Monday. In para el mes: in December. ¡Pero at night!",
                taunts: ["¡Ocho brazos para liarte!", "¡In, on, at… da igual!", "¡Lo escondo donde no es!"],
                hits: ["¡Ay! ¡Cada cosa en su sitio!", "¡Nooo! ¡Sabes dónde está!", "¡Mis ocho brazos se rinden!"]
            )
        case .apostrophe:
            MonsterInfo(
                name: "Ladrón del Apóstrofo",
                tagline: "Roba el 's y lía los posesivos.",
                lesson: "El coche de Tom se dice Tom's car: primero quién lo tiene, con 's. ¿De quién es? se dice Whose? Mío es mine y tuyo es yours. ¡Ojo! It's quiere decir it is, e its es «suyo», de una cosa.",
                emblem: "'s",
                taunts: ["¡Me llevo tu apóstrofo!", "¡El coche de Tom, como en español!", "¡Its, it's… da igual! Jejeje"],
                hits: ["¡Ay! ¡Has puesto el 's!", "¡Nooo! ¡Sabes de quién es!", "¡Me has pillado robando!"]
            )
        case .plurals:
            MonsterInfo(
                name: "Monstruo Multiplicador",
                tagline: "Pone -s a los plurales rebeldes.",
                lesson: "Para decir más de uno casi siempre añadimos una s: one cat, two cats. Pero hay rebeldes: child, children. Man, men. Foot, feet. Tooth, teeth. Mouse, mice. ¡Y sheep no cambia: one sheep, two sheep!",
                emblem: "×2",
                taunts: ["¡Childs, mans, foots! Jejeje", "¡Una -s y listo!", "¡Multiplico tus errores!"],
                hits: ["¡Ay! ¡Te sabes los rebeldes!", "¡Nooo! ¡Children, no childs!", "¡Me divides por cero!"]
            )
        case .bossy:
            MonsterInfo(
                name: "El Mandón",
                tagline: "Mete «to» detrás de can y must.",
                lesson: "Detrás de can, must y could, el verbo va solito, sin to: I can swim. You must listen. Pero have to sí lleva to: I have to go. Para preguntar, can salta delante: Can you swim?",
                taunts: ["¡Te ordeno que pongas to!", "¡Do you can? Jejeje", "¡Aquí mando yo!"],
                hits: ["¡Ay! ¡Can sin to!", "¡Nooo! ¡Ya no me obedeces!", "¡Me has quitado el mando!"]
            )
        case .snail:
            MonsterInfo(
                name: "Caracol Adverbio",
                tagline: "Dice good donde va well.",
                lesson: "Para decir cómo haces algo, añade ly: quick, quickly. Slow, slowly. Hay rebeldes: good se convierte en well, y fast no cambia. Good es cómo es algo: a good singer. Well es cómo lo haces: she sings well.",
                taunts: ["¡Despaaacio… she sings good!", "¡Quick y ya está!", "¡Sin -ly, que es más rápido!"],
                hits: ["¡Ay! ¡Qué -ly más bueno!", "¡Nooo! ¡Well, no good!", "¡Me voy despacito…!"]
            )
        case .linker:
            MonsterInfo(
                name: "El Pegamento",
                tagline: "Se lía al unir frases.",
                lesson: "Para unir dos frases: who para personas, which para cosas y animales, where para sitios, y because para decir por qué. The man who lives here es el hombre que vive aquí. ¡Sin repetir he!",
                taunts: ["¡Pego lo que no va!", "¡Which, who… lo mismo da!", "¡Te pego los dedos! Jejeje"],
                hits: ["¡Ay! ¡Frases bien pegadas!", "¡Nooo! ¡Who para personas!", "¡Me despego!"]
            )
        case .animals:
            Self.vocabulary("Monstruo Zoológico", topic: "animales",
                            tip: "Fíjate en las letras que no suenan: wHale, dolPHin. ¡Y en las dobles: raBBit, paRRot, kiTTen!")
        case .body:
            Self.vocabulary("Doctor Achís", topic: "el cuerpo y la salud",
                            tip: "Los dolores terminan en ache: headache, toothache. La ch de ache suena como una k.")
        case .clothes:
            Self.vocabulary("Ropa Revuelta", topic: "la ropa",
                            tip: "Muchas prendas van siempre en plural: trousers, shorts, glasses, socks, shoes.")
        case .family:
            Self.vocabulary("Familia Liante", topic: "la familia y la gente",
                            tip: "grand- se pega delante: grandmother, grandson, granddaughter (¡con dos d!).")
        case .food:
            Self.vocabulary("Tragón Glotón", topic: "la comida y la bebida",
                            tip: "Mira las letras dobles: coFFee, bOttLe, cHEEse. ¡Y las que no suenan: sanDwich, biscUit!")
        case .home:
            Self.vocabulary("Fantasma de la Casa", topic: "la casa",
                            tip: "Muchas son dos palabras pegadas: bed + room = bedroom, tooth + brush = toothbrush, up + stairs = upstairs.")
        case .school:
            Self.vocabulary("Mochila Traviesa", topic: "el cole y el tiempo libre",
                            tip: "Ojo con la k que no es k: comic, music, picnic terminan en c.")
        case .sports:
            Self.vocabulary("Balón Botón", topic: "los deportes",
                            tip: "A veces la última letra se repite: swim, swimming. ¡Y sin e delante! Se escribe skating, no eskating.")
        case .town:
            Self.vocabulary("Monstruo Callejero", topic: "la ciudad",
                            tip: "library = biblioteca (¡no librería!). Y sin e delante: street, square, station.")
        case .nature:
            Self.vocabulary("Nube Gruñona", topic: "el tiempo y la naturaleza",
                            tip: "El tiempo que hace añade -y: sun → sunny, wind → windy, cloud → cloudy.")
        case .transport:
            Self.vocabulary("Motor Ruidoso", topic: "los transportes",
                            tip: "Cuidado con las parejas que suenan casi igual: ship es barco y sheep es oveja.")
        case .time:
            Self.vocabulary("Calendario Comilón", topic: "los días y el tiempo",
                            tip: "Los días de la semana van SIEMPRE con mayúscula: Monday, Friday, Sunday.")
        case .jobs:
            Self.vocabulary("Disfrazón", topic: "las profesiones",
                            tip: "Muchas profesiones acaban en -er: teacher, farmer, singer, driver.")
        case .numbers:
            Self.vocabulary("Cuentalotodo", topic: "los números",
                            tip: "forty se escribe sin u, aunque four sí la lleve. Ninety sí lleva la e de nine. Y twenty-five va con una rayita en medio.")
        case .feelings:
            Self.vocabulary("Cara de Emociones", topic: "cómo estás y cómo es",
                            tip: "Mira cómo terminan: hungry, thirsty y angry acaban en y. Bored, tired y scared acaban en ed.")
        default:
            preconditionFailure("\(self) is described in Content.swift")
        }
    }

    private static func vocabulary(_ name: String, topic: String, tip: String) -> MonsterInfo {
        MonsterInfo(
            name: name,
            tagline: "Vocabulario: \(topic).",
            lesson: "¡Esta palabra ya la sabes decir! Ahora mírala bien, como si le hicieras una foto, y escríbela otra vez. \(tip)",
            taunts: ["¡Jejeje! ¡Seguro que te falta una letra!", "¡Esta palabra es mía!", "¡Escríbela como suena! Jejeje"],
            hits: ["¡Ay! ¡Letra a letra, perfecta!", "¡Nooo! ¡Te sabes la foto de la palabra!", "¡Ouch! ¡Qué buena memoria!"]
        )
    }
}
