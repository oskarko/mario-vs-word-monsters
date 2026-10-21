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
                lesson: "Tener (cosas, mascotas, pelo, familia) = have GOT / has GOT. El got va pegado detrás: I have got, she has got. En preguntas salta have: Have you got…? Has she got…? En negativas: haven't got, hasn't got. ¡Solo desaparece en las respuestas cortas: Yes, I have!",
                emblem: "got",
                taunts: ["¡Me llevo tu got! Jejeje", "¡Have a secas, que es más corto!", "¡Got, got… ¿dónde está tu got?"],
                hits: ["¡Ay! ¡No has perdido el got!", "¡Nooo! ¡Have got completo!", "¡Grrr! ¡Has encontrado el got!"]
            )
        case .mixer:
            MonsterInfo(
                name: "El Revoltijo",
                tagline: "Desordena las palabras de la frase.",
                lesson: "El adjetivo va ANTES de la cosa: a red car. Tamaño antes que color: a big black cat. always, often, sometimes, never van antes del verbo (I always walk), pero después de is / are (He is never late). Y very well, very much van al final.",
                emblem: "🔀",
                taunts: ["¡Lo pongo todo patas arriba!", "¡Como en español, que da igual!", "¡Revuelve, revuelve! Jejeje"],
                hits: ["¡Ay! ¡Cada palabra en su sitio!", "¡Nooo! ¡Me has ordenado!", "¡Grrr! ¡Qué orden más inglés!"]
            )
        case .yesterday:
            MonsterInfo(
                name: "Reloj del Ayer",
                tagline: "Se olvida de poner el verbo en pasado.",
                lesson: "Para el pasado (yesterday, last week…) el verbo cambia. Muchos añaden -ed: play → played, watch → watched. Los rebeldes hay que aprendérselos: go → went, see → saw, eat → ate, have → had, is → was. Con didn't y Did…? el verbo vuelve a ser normal: I didn't go, Did you see…?",
                emblem: "⏪",
                taunts: ["¡Tic tac! ¡Ayer es igual que hoy!", "¡Goed, eated! Jejeje", "¡El pasado no existe!"],
                hits: ["¡Ay! ¡Ese pasado está perfecto!", "¡Nooo! ¡Te sabes los rebeldes!", "¡Tic… tac… me paro!"]
            )
        case .bigger:
            MonsterInfo(
                name: "Gigante Comparón",
                tagline: "Lía los comparativos y superlativos.",
                lesson: "Palabras cortas: + er / the + est: big → bigger → the biggest. Palabras largas: more / the most: more beautiful, the most beautiful. Rebeldes: good → better → the best, bad → worse → the worst. Y para comparar se usa than (no that).",
                emblem: "📏",
                taunts: ["¡Soy más big que tú!", "¡The most good! Jejeje", "¡Gooder, badder!"],
                hits: ["¡Ay! ¡Eres el mejor comparando!", "¡Nooo! ¡Better, no gooder!", "¡Me has hecho más pequeño!"]
            )
        case .nowNow:
            MonsterInfo(
                name: "Monstruo Ahora-Mismo",
                tagline: "Se come el is / are de las frases con -ing.",
                lesson: "Para lo que pasa AHORA: am / is / are + verbo-ing: She is running. ¡No te olvides del is! Ojo con la ortografía: run → running, swim → swimming, make → making. Lo que haces siempre o cada día va sin -ing: I go to school every day.",
                emblem: "⏳",
                taunts: ["¡Ñam! ¡Me como tu is!", "¡She running, y ya está!", "¡Ahora mismo te engaño!"],
                hits: ["¡Ay! ¡Is + ing, perfecto!", "¡Nooo! ¡Has guardado el is!", "¡Ahora mismo me duele!"]
            )
        case .octopus:
            MonsterInfo(
                name: "Pulpo Preposiciones",
                tagline: "Pone cada cosa en el sitio equivocado.",
                lesson: "Lugar: in (dentro), on (encima), under (debajo), behind (detrás), next to (al lado), between (entre), in front of (delante de), opposite (enfrente), above (encima, sin tocar). Tiempo: at + hora (at seven o'clock), on + día (on Monday), in + mes, estación o parte del día (in December, in summer, in the morning). ¡Pero at night!",
                emblem: "📍",
                taunts: ["¡Ocho brazos para liarte!", "¡In, on, at… da igual!", "¡Lo escondo donde no es!"],
                hits: ["¡Ay! ¡Cada cosa en su sitio!", "¡Nooo! ¡Sabes dónde está!", "¡Mis ocho brazos se rinden!"]
            )
        case .apostrophe:
            MonsterInfo(
                name: "Ladrón del Apóstrofo",
                tagline: "Roba el 's y lía los posesivos.",
                lesson: "El coche de Tom = Tom's car (el dueño primero, con 's). ¿De quién? = Whose…? Mío, tuyo, suyo: mine, yours, his, hers, ours, theirs. Cuidado: its (suyo, de una cosa) ≠ it's (it is), y their (su, de ellos) ≠ there (allí).",
                emblem: "'s",
                taunts: ["¡Me llevo tu apóstrofo!", "¡El coche de Tom, como en español!", "¡Its, it's… da igual! Jejeje"],
                hits: ["¡Ay! ¡Has puesto el 's!", "¡Nooo! ¡Sabes de quién es!", "¡Me has pillado robando!"]
            )
        case .plurals:
            MonsterInfo(
                name: "Monstruo Multiplicador",
                tagline: "Pone -s a los plurales rebeldes.",
                lesson: "Casi todos los plurales llevan -s, pero algunos son rebeldes: child → children, man → men, woman → women, foot → feet, tooth → teeth, mouse → mice, person → people, sheep → sheep. Y ojo: baby → babies, box → boxes, knife → knives, potato → potatoes.",
                emblem: "×2",
                taunts: ["¡Childs, mans, foots! Jejeje", "¡Una -s y listo!", "¡Multiplico tus errores!"],
                hits: ["¡Ay! ¡Te sabes los rebeldes!", "¡Nooo! ¡Children, no childs!", "¡Me divides por cero!"]
            )
        case .bossy:
            MonsterInfo(
                name: "El Mandón",
                tagline: "Mete «to» detrás de can y must.",
                lesson: "Detrás de can, can't, could, must, mustn't y shall el verbo va SOLO, sin to: I can swim, You must listen. Pero have to sí lleva to: I have to go, She has to go. Para preguntar salta el verbo: Can you…? Shall I…? (nunca Do you can…?).",
                emblem: "📢",
                taunts: ["¡Te ordeno que pongas to!", "¡Do you can? Jejeje", "¡Aquí mando yo!"],
                hits: ["¡Ay! ¡Can sin to!", "¡Nooo! ¡Ya no me obedeces!", "¡Me has quitado el mando!"]
            )
        case .snail:
            MonsterInfo(
                name: "Caracol Adverbio",
                tagline: "Dice good donde va well.",
                lesson: "Para decir CÓMO se hace algo, añade -ly: quick → quickly, slow → slowly, careful → carefully, happy → happily. Rebeldes: good → well, fast → fast. Good dice cómo ES algo (a good singer). Well dice cómo se HACE (she sings well).",
                emblem: "🐌",
                taunts: ["¡Despaaacio… she sings good!", "¡Quick y ya está!", "¡Sin -ly, que es más rápido!"],
                hits: ["¡Ay! ¡Qué -ly más bueno!", "¡Nooo! ¡Well, no good!", "¡Me voy despacito…!"]
            )
        case .linker:
            MonsterInfo(
                name: "El Pegamento",
                tagline: "Se lía al unir frases.",
                lesson: "Para unir frases: who (personas), which (cosas y animales), where (lugares), because (porque), but (pero), when (cuando). Y no repitas quién es: The man who lives here (no «who he lives»).",
                emblem: "🔗",
                taunts: ["¡Pego lo que no va!", "¡Which, who… lo mismo da!", "¡Te pego los dedos! Jejeje"],
                hits: ["¡Ay! ¡Frases bien pegadas!", "¡Nooo! ¡Who para personas!", "¡Me despego!"]
            )
        case .animals:
            Self.vocabulary("Monstruo Zoológico", topic: "animales", emblem: "🐾",
                            tip: "Fíjate en las letras que no suenan: wHale, dolPHin. ¡Y en las dobles: raBBit, paRRot, kiTTen!")
        case .body:
            Self.vocabulary("Doctor Achís", topic: "el cuerpo y la salud", emblem: "🤧",
                            tip: "Los dolores se forman con -ache: head + ache = headache, tooth + ache = toothache. La ch de ache suena k.")
        case .clothes:
            Self.vocabulary("Ropa Revuelta", topic: "la ropa", emblem: "👕",
                            tip: "Muchas prendas van siempre en plural: trousers, shorts, glasses, socks, shoes.")
        case .family:
            Self.vocabulary("Familia Liante", topic: "la familia y la gente", emblem: "👪",
                            tip: "grand- se pega delante: grandmother, grandson, granddaughter (¡con dos d!).")
        case .food:
            Self.vocabulary("Tragón Glotón", topic: "la comida y la bebida", emblem: "🍔",
                            tip: "Mira las letras dobles: coFFee, bOttLe, cHEEse. ¡Y las que no suenan: sanDwich, biscUit!")
        case .home:
            Self.vocabulary("Fantasma de la Casa", topic: "la casa", emblem: "🏠",
                            tip: "Muchas son dos palabras pegadas: bed + room = bedroom, tooth + brush = toothbrush, up + stairs = upstairs.")
        case .school:
            Self.vocabulary("Mochila Traviesa", topic: "el cole y el tiempo libre", emblem: "🎒",
                            tip: "Ojo con la k que no es k: comic, music, picnic terminan en c.")
        case .sports:
            Self.vocabulary("Balón Botón", topic: "los deportes", emblem: "⚽",
                            tip: "Los deportes con -ing doblan a veces la consonante: swim → swimming. ¡Y nada de e delante: skating, no eskating!")
        case .town:
            Self.vocabulary("Monstruo Callejero", topic: "la ciudad", emblem: "🏙️",
                            tip: "library = biblioteca (¡no librería!). Y sin e delante: street, square, station.")
        case .nature:
            Self.vocabulary("Nube Gruñona", topic: "el tiempo y la naturaleza", emblem: "🌦️",
                            tip: "El tiempo que hace añade -y: sun → sunny, wind → windy, cloud → cloudy.")
        case .transport:
            Self.vocabulary("Motor Ruidoso", topic: "los transportes", emblem: "🚗",
                            tip: "Cuidado con las parejas: ship (barco) y sheep (oveja), plane (avión) y plain.")
        case .time:
            Self.vocabulary("Calendario Comilón", topic: "los días y el tiempo", emblem: "📅",
                            tip: "Los días de la semana van SIEMPRE con mayúscula: Monday, Friday, Sunday.")
        case .jobs:
            Self.vocabulary("Disfrazón", topic: "las profesiones", emblem: "🧑‍🚒",
                            tip: "Muchas profesiones acaban en -er: teacher, farmer, singer, driver.")
        case .numbers:
            Self.vocabulary("Cuentalotodo", topic: "los números", emblem: "🔢",
                            tip: "forty va SIN u (aunque four la lleve) y ninety CON e. Los números compuestos llevan guion: twenty-five.")
        case .feelings:
            Self.vocabulary("Cara de Emociones", topic: "cómo estás y cómo es", emblem: "😀",
                            tip: "Fíjate en el final: hungry, thirsty, angry acaban en -y. bored, tired, scared, excited acaban en -ed.")
        default:
            preconditionFailure("\(self) is described in Content.swift")
        }
    }

    private static func vocabulary(_ name: String, topic: String, emblem: String, tip: String) -> MonsterInfo {
        MonsterInfo(
            name: name,
            tagline: "Vocabulario: \(topic).",
            lesson: "Estas palabras ya las sabes decir. Ahora toca escribirlas bien: mírala, dila, tápala, escríbela y compruébala. \(tip)",
            emblem: emblem,
            taunts: ["¡Jejeje! ¡Seguro que te falta una letra!", "¡Esta palabra es mía!", "¡Escríbela como suena! Jejeje"],
            hits: ["¡Ay! ¡Letra a letra, perfecta!", "¡Nooo! ¡Te sabes la foto de la palabra!", "¡Ouch! ¡Qué buena memoria!"]
        )
    }
}
