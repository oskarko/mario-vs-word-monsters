import Foundation

/// The rest of the Cambridge Movers (A1) syllabus. The wrong versions are the typical mistakes
/// of Spanish-speaking children who already speak English: spelling by sound and Spanish word order.
/// "have got" is one of Mario's own errors; the grammar and vocabulary monsters start switched off.
extension Curriculum {
    // MARK: - El Got Perdido: have got without got

    static let gotLost: [Card] = [
        s(.gotLost, "I have got a dog.", "Tengo un perro.", "🐶", ["I have a dog.", "I got a dog."], tip: "En el cole decimos have GOT: I have got a dog. ¡Que no se pierda el got!"),
        s(.gotLost, "She has got a new bike.", "Ella tiene una bici nueva.", "🚲", ["She has a new bike.", "She have got a new bike."]),
        s(.gotLost, "We have got a big garden.", "Tenemos un jardín grande.", "🌳", ["We have a big garden.", "We has got a big garden."]),
        s(.gotLost, "Have you got a pet?", "¿Tienes una mascota?", "🐹", ["Have you a pet?", "You have got a pet?"], tip: "En la pregunta salta have, pero el got se queda detrás de ti: Have you GOT…?"),
        s(.gotLost, "Has he got a sister?", "¿Tiene él una hermana?", "👧", ["Has he a sister?", "He has got a sister?"]),
        s(.gotLost, "I haven't got a brother.", "No tengo hermano.", "👦", ["I haven't a brother.", "I no have got a brother."], tip: "No tengo = I haven't GOT. ¡El got también va en las negativas!"),
        s(.gotLost, "She hasn't got long hair.", "Ella no tiene el pelo largo.", "💇", ["She hasn't long hair.", "She no has got long hair."]),
        s(.gotLost, "Yes, I have.", "Sí, tengo.", "👍", ["Yes, I have got.", "Yes, I got."], tip: "En las respuestas cortas el got se queda en casa: Yes, I have. / No, I haven't."),
        s(.gotLost, "No, she hasn't.", "No, ella no tiene.", "👎", ["No, she hasn't got.", "No, she no has."], tip: "Respuesta corta: No, she hasn't. Sin got."),
        s(.gotLost, "They have got three cats.", "Ellos tienen tres gatos.", "🐈", ["They have three cats.", "They has got three cats."]),
        s(.gotLost, "My dad has got a beard.", "Mi padre tiene barba.", "🧔", ["My dad has a beard.", "My dad have got a beard."]),
        s(.gotLost, "What have you got in your bag?", "¿Qué tienes en tu mochila?", "🎒", ["What you have got in your bag?", "What have you in your bag?"]),
        s(.gotLost, "How many brothers have you got?", "¿Cuántos hermanos tienes?", "👬", ["How many brothers you have got?", "How many brothers have you?"]),
        s(.gotLost, "He has got blue eyes.", "Él tiene los ojos azules.", "👀", ["He has blue eyes.", "He have got blue eyes."]),
        s(.gotLost, "Have they got a car?", "¿Tienen ellos coche?", "🚗", ["Have they a car?", "They have got a car?"]),
        s(.gotLost, "I have got a headache.", "Me duele la cabeza.", "🤕", ["I have a headache.", "I have got headache."], tip: "Me duele la cabeza = I have GOT A headache. ¡Con got y con a!"),
    ]

    static let moversGrammar: [Card] = mixer + yesterday + bigger + nowNow + octopus + apostrophe + plurals + bossy + snail + linker + twinTimes

    // MARK: - El Revoltijo: word order

    static let mixer: [Card] = [
        s(.mixer, "I have got a red bike.", "Tengo una bici roja.", "🚲", ["I have got a bike red.", "I have got red a bike."], tip: "El color va ANTES de la cosa: a red bike."),
        s(.mixer, "She has got a big black cat.", "Ella tiene un gato negro grande.", "🐈‍⬛", ["She has got a cat big black.", "She has got a black big cat."], tip: "Primero el tamaño, luego el color: a big black cat."),
        s(.mixer, "I always walk to school.", "Siempre voy andando al colegio.", "🚶", ["I walk always to school.", "Always I walk to school."], tip: "always, often, never… van ANTES del verbo: I always walk."),
        s(.mixer, "He is never late.", "Él nunca llega tarde.", "⏰", ["He never is late.", "He is late never."], tip: "Con is / are es al revés: never va DESPUÉS: He is never late."),
        s(.mixer, "We often play in the park.", "A menudo jugamos en el parque.", "🛝", ["We play often in the park.", "We often play in park."]),
        s(.mixer, "My sister sometimes reads comics.", "Mi hermana a veces lee cómics.", "📕", ["My sister reads sometimes comics.", "My sister sometimes read comics."]),
        s(.mixer, "It is a beautiful day.", "Hace un día precioso.", "🌞", ["It is a day beautiful.", "Is a beautiful day."]),
        s(.mixer, "There is a small brown dog in the garden.", "Hay un perro marrón pequeño en el jardín.", "🐕", ["There is a dog small brown in the garden.", "There is a brown small dog in the garden."]),
        s(.mixer, "I play football with my friends on Saturdays.", "Juego al fútbol con mis amigos los sábados.", "⚽", ["I play with my friends football on Saturdays.", "I play football on Saturdays with my friends on."]),
        s(.mixer, "She speaks English very well.", "Ella habla inglés muy bien.", "🗣️", ["She speaks very well English.", "She speak English very well."], tip: "very well va al FINAL: She speaks English very well."),
        s(.mixer, "I like ice cream very much.", "Me gusta mucho el helado.", "🍦", ["I like very much ice cream.", "Me like ice cream very much."], tip: "very much va al FINAL: I like ice cream very much."),
        s(.mixer, "Where is my new blue jacket?", "¿Dónde está mi chaqueta azul nueva?", "🧥", ["Where is my jacket new blue?", "Where my new blue jacket is?"]),
        s(.mixer, "They usually have lunch at school.", "Normalmente comen en el colegio.", "🍽️", ["They have usually lunch at school.", "They usually have lunch in the school at."]),
        s(.mixer, "My brother is very tall.", "Mi hermano es muy alto.", "🦒", ["My brother very is tall.", "My brother is tall very."]),
        s(.mixer, "He has got short curly hair.", "Él tiene el pelo corto y rizado.", "🌀", ["He has got hair short curly.", "He has got curly short hair."]),
    ]

    // MARK: - Reloj del Ayer: past simple

    static let yesterday: [Card] = [
        s(.yesterday, "I played football yesterday.", "Ayer jugué al fútbol.", "⚽", ["I play football yesterday.", "I plaied football yesterday."], tip: "Ayer = pasado: play + ed = played."),
        s(.yesterday, "We went to the beach last summer.", "Fuimos a la playa el verano pasado.", "🏖️", ["We go to the beach last summer.", "We goed to the beach last summer."], tip: "go es rebelde: go → went."),
        s(.yesterday, "She watched a film last night.", "Ella vio una película anoche.", "🎬", ["She watch a film last night.", "She watchd a film last night."]),
        s(.yesterday, "I saw a whale on holiday.", "Vi una ballena en vacaciones.", "🐋", ["I see a whale on holiday.", "I seed a whale on holiday."], tip: "see es rebelde: see → saw."),
        s(.yesterday, "He ate a big pizza.", "Él se comió una pizza grande.", "🍕", ["He eated a big pizza.", "He eat a big pizza."], tip: "eat es rebelde: eat → ate."),
        s(.yesterday, "We were at the zoo on Sunday.", "Estuvimos en el zoo el domingo.", "🦓", ["We was at the zoo on Sunday.", "We are at the zoo on Sunday."], tip: "En pasado, is y am se convierten en was. Y are se convierte en were."),
        s(.yesterday, "It was very cold yesterday.", "Ayer hizo mucho frío.", "🥶", ["It were very cold yesterday.", "Was very cold yesterday."]),
        s(.yesterday, "I didn't go to school on Monday.", "No fui al colegio el lunes.", "🏫", ["I didn't went to school on Monday.", "I no went to school on Monday."], tip: "Con didn't el verbo vuelve a ser normal: didn't GO (no didn't went)."),
        s(.yesterday, "Did you have a good weekend?", "¿Pasaste un buen fin de semana?", "🎈", ["Did you had a good weekend?", "You had a good weekend?"], tip: "Con Did…? el verbo vuelve a ser normal: Did you HAVE…?"),
        s(.yesterday, "My mum bought a new car.", "Mi madre compró un coche nuevo.", "🚗", ["My mum buyed a new car.", "My mum buy a new car."], tip: "buy es rebelde: buy → bought."),
        s(.yesterday, "They had a picnic in the park.", "Hicieron un picnic en el parque.", "🧺", ["They haved a picnic in the park.", "They has a picnic in the park."], tip: "have es rebelde: have → had."),
        s(.yesterday, "Tom stopped the ball.", "Tom paró el balón.", "🥅", ["Tom stoped the ball.", "Tom stop the ball."], tip: "stop → stopped: la p se dobla."),
        s(.yesterday, "Where did you go yesterday?", "¿Adónde fuiste ayer?", "🗺️", ["Where did you went yesterday?", "Where you went yesterday?"]),
        s(.yesterday, "She didn't like the soup.", "A ella no le gustó la sopa.", "🍲", ["She didn't liked the soup.", "She no liked the soup."]),
        s(.yesterday, "I wrote a letter to my grandma.", "Escribí una carta a mi abuela.", "✉️", ["I writed a letter to my grandma.", "I write a letter to my grandma."], tip: "write es rebelde: write → wrote."),
        s(.yesterday, "We swam in the sea.", "Nadamos en el mar.", "🌊", ["We swimmed in the sea.", "We swim in the sea."], tip: "swim es rebelde: swim → swam."),
        w(.yesterday, "went", "fui, fue… (de go)", "🚶", ["goed", "wented"]),
        w(.yesterday, "bought", "compré, compró… (de buy)", "🛍️", ["buyed", "bougth"]),
        w(.yesterday, "saw", "vi, vio… (de see)", "👀", ["seed", "sow"]),
        w(.yesterday, "caught", "cogí, cogió… (de catch)", "🧤", ["catched", "cought"]),
    ]

    // MARK: - Gemelos Hoy-Ayer: present simple vs past simple

    static let twinTimes: [Card] = [
        s(.twinTimes, "I go to school every day.", "Voy al colegio todos los días.", "🏫", ["I went to school every day.", "I goes to school every day."], tip: "every day = presente: go. (Ayer sería went.)"),
        s(.twinTimes, "I went to school yesterday.", "Ayer fui al colegio.", "🎒", ["I go to school yesterday.", "I goed to school yesterday."], tip: "yesterday = pasado: go → went."),
        s(.twinTimes, "She goes to the park on Saturdays.", "Ella va al parque los sábados.", "🛝", ["She go to the park on Saturdays.", "She went to the park on Saturdays."], tip: "Con she, presente: goes."),
        s(.twinTimes, "She went to the park last Saturday.", "Ella fue al parque el sábado pasado.", "🌳", ["She goes to the park last Saturday.", "She goed to the park last Saturday."], tip: "last Saturday = pasado: went, y sin s."),
        s(.twinTimes, "He does his homework after school.", "Él hace los deberes después del cole.", "✏️", ["He do his homework after school.", "He did his homework after school."], tip: "Presente con he: does."),
        s(.twinTimes, "He did his homework yesterday.", "Él hizo los deberes ayer.", "📒", ["He does his homework yesterday.", "He doed his homework yesterday."], tip: "do en pasado = did (¡sin s, para todos!)."),
        s(.twinTimes, "Do you like pizza?", "¿Te gusta la pizza?", "🍕", ["Does you like pizza?", "Did you like pizza?"], tip: "Presente con you: Do. (Did preguntaría por el pasado.)"),
        s(.twinTimes, "Does he like pizza?", "¿Le gusta la pizza a él?", "🍕", ["Do he like pizza?", "Does he likes pizza?"], tip: "Con he/she/it: Does, y el verbo solito: like (sin s)."),
        s(.twinTimes, "Did you go to the beach?", "¿Fuiste a la playa?", "🏖️", ["Did you went to the beach?", "Do you went to the beach?"], tip: "Con Did, el verbo vuelve a ser normal: Did you GO…?"),
        s(.twinTimes, "Does she go to the beach?", "¿Va ella a la playa?", "🌊", ["Does she goes to the beach?", "Does she went to the beach?"], tip: "Con Does, el verbo sin s: Does she GO…?"),
        s(.twinTimes, "I don't like soup.", "No me gusta la sopa.", "🍲", ["I doesn't like soup.", "I didn't likes soup."], tip: "I don't = presente. Detrás, el verbo normal."),
        s(.twinTimes, "She doesn't like soup.", "A ella no le gusta la sopa.", "🥣", ["She don't like soup.", "She doesn't likes soup."], tip: "Con she: doesn't, y el verbo sin s."),
        s(.twinTimes, "She didn't like the soup.", "A ella no le gustó la sopa.", "😖", ["She doesn't liked the soup.", "She didn't liked the soup."], tip: "didn't ya es pasado: el verbo se queda normal (like)."),
        s(.twinTimes, "We didn't go to the zoo.", "No fuimos al zoo.", "🦒", ["We didn't went to the zoo.", "We don't went to the zoo."], tip: "didn't GO, no didn't went."),
        s(.twinTimes, "My dad watches TV every night.", "Mi padre ve la tele todas las noches.", "📺", ["My dad watch TV every night.", "My dad watched TV every night."], tip: "every night = presente, y con dad (he) lleva es: watches."),
        s(.twinTimes, "My dad watched TV last night.", "Mi padre vio la tele anoche.", "📡", ["My dad watches TV last night.", "My dad watchd TV last night."], tip: "last night = pasado: watch + ed."),
        s(.twinTimes, "They eat lunch at one o'clock.", "Ellos comen a la una.", "🍝", ["They ate lunch at one o'clock.", "They eats lunch at one o'clock."], tip: "Presente con they: eat, sin s."),
        s(.twinTimes, "They ate lunch at home yesterday.", "Ayer comieron en casa.", "🏠", ["They eated lunch at home yesterday.", "They eat lunch at home yesterday."], tip: "eat es rebelde: eat → ate."),
        s(.twinTimes, "He has a dog.", "Él tiene un perro.", "🐕", ["He have a dog.", "He had a dog."], tip: "Presente con he: has. (had es el pasado.)"),
        s(.twinTimes, "He had a bike last year.", "Él tuvo una bici el año pasado.", "🚲", ["He has a bike last year.", "He haved a bike last year."], tip: "have → had, para todos."),
        s(.twinTimes, "Mario plays football on Mondays.", "Mario juega al fútbol los lunes.", "⚽", ["Mario play football on Mondays.", "Mario played football on Mondays."], tip: "Costumbre de siempre: presente, con s para Mario (he)."),
        s(.twinTimes, "Mario played football yesterday.", "Mario jugó al fútbol ayer.", "🥅", ["Mario plays football yesterday.", "Mario plaied football yesterday."], tip: "play + ed = played (la y se queda)."),
        s(.twinTimes, "What does she do at weekends?", "¿Qué hace ella los fines de semana?", "🗓️", ["What do she do at weekends?", "What does she does at weekends?"], tip: "Does + verbo solito: What does she DO?"),
        s(.twinTimes, "What did you do yesterday?", "¿Qué hiciste ayer?", "🤔", ["What did you did yesterday?", "What do you did yesterday?"], tip: "Did + verbo solito: What did you DO?"),
        s(.twinTimes, "My mum buys bread every morning.", "Mi madre compra pan cada mañana.", "🥖", ["My mum buy bread every morning.", "My mum bought bread every morning."], tip: "Presente con mum (she): buys."),
        s(.twinTimes, "My mum bought bread this morning.", "Mi madre compró pan esta mañana.", "🍞", ["My mum buyed bread this morning.", "My mum buys bread this morning."], tip: "buy es rebelde: buy → bought."),
        s(.twinTimes, "We see our friends at school.", "Vemos a nuestros amigos en el cole.", "👫", ["We saw our friends at school.", "We sees our friends at school."], tip: "Presente con we: see, sin s."),
        s(.twinTimes, "We saw a big whale yesterday.", "Ayer vimos una ballena grande.", "🐳", ["We seed a big whale yesterday.", "We see a big whale yesterday."], tip: "see → saw."),
        s(.twinTimes, "It rains a lot in winter.", "Llueve mucho en invierno.", "🌧️", ["It rain a lot in winter.", "It rained a lot in winter."], tip: "Con it, presente: rains."),
        s(.twinTimes, "It rained all day on Sunday.", "Llovió todo el día el domingo.", "☔", ["It rains all day on Sunday.", "It rainned all day on Sunday."], tip: "rain + ed = rained."),
        w(.twinTimes, "did", "hice, hizo… (de do)", "✅", ["dit", "deed"]),
        w(.twinTimes, "went", "fui, fue… (de go)", "🚶", ["want", "wend"]),
        w(.twinTimes, "had", "tuve, tuvo… (de have)", "🎁", ["haved", "hat"]),
        w(.twinTimes, "came", "vine, vino… (de come)", "👋", ["comed", "kame"]),
        w(.twinTimes, "took", "cogí, cogió… (de take)", "🤲", ["taked", "tuk"]),
        w(.twinTimes, "ran", "corrí, corrió… (de run)", "🏃", ["runned", "ram"]),
    ]

    // MARK: - Gigante Comparón: comparatives and superlatives

    static let bigger: [Card] = [
        s(.bigger, "An elephant is bigger than a lion.", "Un elefante es más grande que un león.", "🐘", ["An elephant is more big than a lion.", "An elephant is bigger that a lion."], tip: "big es corta, así que bigger, sin more. ¡Y «que» se dice than!"),
        s(.bigger, "My brother is taller than me.", "Mi hermano es más alto que yo.", "📏", ["My brother is more tall than me.", "My brother is taller that me."]),
        s(.bigger, "The whale is the biggest animal.", "La ballena es el animal más grande.", "🐋", ["The whale is the most big animal.", "The whale is the bigest animal."], tip: "big → the biggest: la g se dobla."),
        s(.bigger, "This book is more interesting than that one.", "Este libro es más interesante que ese.", "📚", ["This book is interestinger than that one.", "This book is more interesting that that one."], tip: "interesting es larga, así que more interesting."),
        s(.bigger, "She is the best player in the team.", "Ella es la mejor jugadora del equipo.", "🏅", ["She is the goodest player in the team.", "She is the better player in the team."], tip: "good es rebelde: good → better → the best."),
        s(.bigger, "My drawing is better than yours.", "Mi dibujo es mejor que el tuyo.", "🎨", ["My drawing is gooder than yours.", "My drawing is more good than yours."]),
        s(.bigger, "Today is worse than yesterday.", "Hoy es peor que ayer.", "🌧️", ["Today is badder than yesterday.", "Today is more bad than yesterday."], tip: "bad es rebelde: bad → worse → the worst."),
        s(.bigger, "A horse is faster than a cow.", "Un caballo es más rápido que una vaca.", "🐎", ["A horse is more fast than a cow.", "A horse is faster that a cow."]),
        s(.bigger, "Who is the youngest in your family?", "¿Quién es el más joven de tu familia?", "👶", ["Who is the most young in your family?", "Who is the younger in your family?"]),
        s(.bigger, "It is hotter today.", "Hoy hace más calor.", "🥵", ["It is more hot today.", "It is hoter today."], tip: "hot → hotter: la t se dobla."),
        s(.bigger, "My bag is heavier than your bag.", "Mi mochila pesa más que la tuya.", "🎒", ["My bag is more heavy than your bag.", "My bag is heavyer than your bag."], tip: "Si acaba en -y, cambia a -ier: heavy → heavier."),
        s(.bigger, "This is the most beautiful beach.", "Esta es la playa más bonita.", "🏝️", ["This is the beautifulest beach.", "This is the more beautiful beach."]),
        s(.bigger, "Lions are more dangerous than cats.", "Los leones son más peligrosos que los gatos.", "🦁", ["Lions are dangerouser than cats.", "Lions are more dangerous that cats."]),
        s(.bigger, "Paul is the funniest boy in my class.", "Paul es el niño más gracioso de mi clase.", "🤣", ["Paul is the funnyest boy in my class.", "Paul is the most funny boy in my class."]),
        s(.bigger, "My grandpa is older than my grandma.", "Mi abuelo es mayor que mi abuela.", "👴", ["My grandpa is more old than my grandma.", "My grandpa is older that my grandma."]),
        w(.bigger, "bigger", "más grande", "🐘", ["biger", "more big"]),
        w(.bigger, "happier", "más feliz", "😄", ["happyer", "more happy"]),
        w(.bigger, "better", "mejor", "👍", ["gooder", "beter"]),
        w(.bigger, "worse", "peor", "👎", ["badder", "wors"]),
    ]

    // MARK: - Monstruo Ahora-Mismo: present continuous

    static let nowNow: [Card] = [
        s(.nowNow, "She is running in the park.", "Ella está corriendo en el parque.", "🏃‍♀️", ["She running in the park.", "She is runing in the park."], tip: "Está corriendo = IS running. Y run → running, con dos n."),
        s(.nowNow, "I am swimming now.", "Estoy nadando ahora.", "🏊", ["I swimming now.", "I am swiming now."]),
        s(.nowNow, "They are playing football.", "Están jugando al fútbol.", "⚽", ["They playing football.", "They are play football."]),
        s(.nowNow, "What are you doing?", "¿Qué estás haciendo?", "🤔", ["What you are doing?", "What are you do?"]),
        s(.nowNow, "He isn't watching TV.", "Él no está viendo la tele.", "📺", ["He no watching TV.", "He isn't watch TV."]),
        s(.nowNow, "Is it raining?", "¿Está lloviendo?", "🌧️", ["It is raining?", "Is it rainning?"]),
        s(.nowNow, "We are making a cake.", "Estamos haciendo una tarta.", "🎂", ["We are makeing a cake.", "We making a cake."], tip: "make → making: la e se va."),
        s(.nowNow, "Look! The baby is sleeping.", "¡Mira! El bebé está durmiendo.", "👶", ["Look! The baby sleeping.", "Look! The baby is sleep."]),
        s(.nowNow, "My dad is cooking dinner.", "Mi padre está haciendo la cena.", "🍳", ["My dad cooking dinner.", "My dad is cook dinner."]),
        s(.nowNow, "Are you listening to me?", "¿Me estás escuchando?", "👂", ["You are listening to me?", "Are you listen to me?"]),
        s(.nowNow, "The children are sitting on the floor.", "Los niños están sentados en el suelo.", "🧒", ["The children sitting on the floor.", "The children are siting on the floor."]),
        s(.nowNow, "I am writing an email.", "Estoy escribiendo un correo.", "📧", ["I am writting an email.", "I writing an email."], tip: "write → writing: la e se va y la t NO se dobla."),
        s(.nowNow, "I go to school every day.", "Voy al colegio todos los días.", "🏫", ["I am going to school every day.", "I goes to school every day."], tip: "Lo que haces SIEMPRE o cada día va sin -ing: I go to school every day."),
        s(.nowNow, "She is wearing a red dress.", "Ella lleva un vestido rojo.", "👗", ["She wearing a red dress.", "She is wear a red dress."]),
        s(.nowNow, "We aren't playing now.", "No estamos jugando ahora.", "⏸️", ["We no playing now.", "We aren't play now."]),
        w(.nowNow, "running", "corriendo", "🏃", ["runing", "runnin"]),
        w(.nowNow, "swimming", "nadando", "🏊", ["swiming", "swimmin"]),
        w(.nowNow, "making", "haciendo", "🧁", ["makeing", "maiking"]),
        w(.nowNow, "sitting", "sentado", "🪑", ["siting", "sittin"]),
    ]

    // MARK: - Pulpo Preposiciones: place and time

    static let octopus: [Card] = [
        s(.octopus, "The cat is under the table.", "El gato está debajo de la mesa.", "🐈", ["The cat is down the table.", "The cat is under table."], tip: "Debajo de = under."),
        s(.octopus, "The ball is behind the sofa.", "La pelota está detrás del sofá.", "⚽", ["The ball is back the sofa.", "The ball is behind sofa."], tip: "Detrás de = behind."),
        s(.octopus, "The bank is next to the park.", "El banco está al lado del parque.", "🏦", ["The bank is next the park.", "The bank is next of the park."], tip: "Al lado de = next TO."),
        s(.octopus, "The shop is between the bank and the library.", "La tienda está entre el banco y la biblioteca.", "🏪", ["The shop is between of the bank and the library.", "The shop is in the middle the bank and the library."], tip: "Entre = between, sin of."),
        s(.octopus, "The car is in front of the house.", "El coche está delante de la casa.", "🚗", ["The car is in front the house.", "The car is front of the house."], tip: "Delante de = IN front OF."),
        s(.octopus, "The school is opposite the park.", "El colegio está enfrente del parque.", "🏫", ["The school is opposite of the park.", "The school is in front the park."], tip: "Enfrente de = opposite, sin of."),
        s(.octopus, "My birthday is in December.", "Mi cumpleaños es en diciembre.", "🎂", ["My birthday is on December.", "My birthday is at December."], tip: "Meses: IN December."),
        s(.octopus, "I get up at seven o'clock.", "Me levanto a las siete.", "⏰", ["I get up in seven o'clock.", "I get up on seven o'clock."], tip: "Horas: AT seven o'clock."),
        s(.octopus, "We go swimming on Fridays.", "Vamos a nadar los viernes.", "🏊", ["We go swimming in Fridays.", "We go swimming the Fridays."], tip: "Días: ON Friday."),
        s(.octopus, "I read in the evening.", "Leo por la tarde.", "📖", ["I read at the evening.", "I read on the evening."], tip: "Partes del día: IN the morning, IN the afternoon, IN the evening."),
        s(.octopus, "I sleep at night.", "Duermo por la noche.", "🌙", ["I sleep in the night.", "I sleep on night."], tip: "¡La rebelde! AT night."),
        s(.octopus, "The picture is above the bed.", "El cuadro está encima de la cama.", "🖼️", ["The picture is on top the bed.", "The picture is up the bed."], tip: "Encima, pero sin tocar, se dice above."),
        s(.octopus, "We go skiing in winter.", "Vamos a esquiar en invierno.", "⛷️", ["We go skiing on winter.", "We go skiing at winter."], tip: "Con el invierno y el verano va in: in winter, in summer."),
        s(.octopus, "The book is on the shelf.", "El libro está en la estantería.", "📚", ["The book is in the shelf.", "The book is at the shelf."]),
        s(.octopus, "Emma is waiting at the bus stop.", "Emma está esperando en la parada.", "🚏", ["Emma is waiting in the bus stop.", "Emma is waiting on the bus stop."]),
        s(.octopus, "I am good at drawing.", "Se me da bien dibujar.", "✏️", ["I am good in drawing.", "I am good for drawing."], tip: "Se me da bien = I am good AT."),
    ]

    // MARK: - Ladrón del Apóstrofo: possessives

    static let apostrophe: [Card] = [
        s(.apostrophe, "This is Tom's bike.", "Esta es la bici de Tom.", "🚲", ["This is the bike of Tom.", "This is Toms bike."], tip: "La bici de Tom = Tom's bike: el dueño primero, con 's."),
        s(.apostrophe, "That is my sister's room.", "Esa es la habitación de mi hermana.", "🛏️", ["That is the room of my sister.", "That is my sisters room."]),
        s(.apostrophe, "Whose bag is this?", "¿De quién es esta mochila?", "🎒", ["Who's bag is this?", "Of who is this bag?"], tip: "¿De quién? = Whose. Who's significa who is."),
        s(.apostrophe, "It's mine.", "Es mío.", "🙋", ["It's my.", "Is mine."], tip: "Mío = mine (my siempre va con algo detrás: my bag)."),
        s(.apostrophe, "Is this yours?", "¿Esto es tuyo?", "🤲", ["Is this your?", "Is this of you?"]),
        s(.apostrophe, "The cat is eating its food.", "El gato está comiendo su comida.", "🐱", ["The cat is eating it's food.", "The cat is eating it food."], tip: "its, de una cosa o un animal, va sin apóstrofo. It's quiere decir it is."),
        s(.apostrophe, "Their house is very big.", "Su casa (de ellos) es muy grande.", "🏡", ["There house is very big.", "They house is very big."], tip: "their = su (de ellos). there = allí."),
        s(.apostrophe, "Emma's hair is long.", "El pelo de Emma es largo.", "💇‍♀️", ["Emma hair is long.", "The hair of Emma is long."]),
        s(.apostrophe, "Is that your mum's car?", "¿Ese es el coche de tu madre?", "🚙", ["Is that the car of your mum?", "Is that your mums car?"]),
        s(.apostrophe, "This pencil is hers.", "Este lápiz es suyo (de ella).", "✏️", ["This pencil is her.", "This pencil is of her."]),
        s(.apostrophe, "Our teacher's name is Paul.", "Nuestro profe se llama Paul.", "🧑‍🏫", ["Our teachers name is Paul.", "Our teacher name is Paul."]),
        s(.apostrophe, "Whose shoes are these?", "¿De quién son estos zapatos?", "👟", ["Who's shoes are these?", "Whose shoes is these?"]),
        s(.apostrophe, "They're playing in their garden.", "Están jugando en su jardín.", "🌷", ["They're playing in there garden.", "Their playing in their garden."]),
        s(.apostrophe, "My friend's dog is called Max.", "El perro de mi amigo se llama Max.", "🐕", ["My friends dog is called Max.", "The dog of my friend is called Max."]),
        s(.apostrophe, "That ball is ours.", "Esa pelota es nuestra.", "⚽", ["That ball is our.", "That ball is of us."]),
        s(.apostrophe, "His name is Tom and her name is Emma.", "Él se llama Tom y ella se llama Emma.", "👫", ["He name is Tom and she name is Emma.", "His name is Tom and his name is Emma."], tip: "De él = his. De ella = her."),
    ]

    // MARK: - Monstruo Multiplicador: irregular plurals

    static let plurals: [Card] = [
        w(.plurals, "children", "niños (child → children)", "🧒", ["childs", "childrens"]),
        w(.plurals, "men", "hombres (man → men)", "👨", ["mans", "mens"]),
        w(.plurals, "women", "mujeres (woman → women)", "👩", ["womans", "wimen"], tip: "woman → women: suena «uímen» pero se escribe w-o-m-e-n."),
        w(.plurals, "feet", "pies (foot → feet)", "🦶", ["foots", "feets"]),
        w(.plurals, "teeth", "dientes (tooth → teeth)", "🦷", ["tooths", "teeths"]),
        w(.plurals, "mice", "ratones (mouse → mice)", "🐭", ["mouses", "mices"]),
        w(.plurals, "sheep", "ovejas (sheep → sheep)", "🐑", ["sheeps", "ships"], tip: "sheep no cambia: one sheep, two sheep."),
        w(.plurals, "people", "personas (person → people)", "👥", ["peoples", "pipol"]),
        w(.plurals, "babies", "bebés (baby → babies)", "👶", ["babys", "babyes"], tip: "baby, babies: la y se cambia por ies."),
        w(.plurals, "boxes", "cajas (box → boxes)", "📦", ["boxs", "boxis"], tip: "Si acaba en x, s, sh o ch, añade es: box, boxes."),
        w(.plurals, "buses", "autobuses (bus → buses)", "🚌", ["buss", "buzes"]),
        w(.plurals, "knives", "cuchillos (knife → knives)", "🔪", ["knifes", "nives"], tip: "knife → knives: la f cambia a v. Y la k no suena."),
        w(.plurals, "potatoes", "patatas (potato → potatoes)", "🥔", ["potatos", "potatoe"]),
        w(.plurals, "watches", "relojes (watch → watches)", "⌚", ["watchs", "wotches"]),
        w(.plurals, "strawberries", "fresas (strawberry → strawberries)", "🍓", ["strawberrys", "strawberies"]),
        s(.plurals, "I have got two feet.", "Tengo dos pies.", "🦶", ["I have got two foots.", "I have got two feets."]),
        s(.plurals, "There are three children in the garden.", "Hay tres niños en el jardín.", "🧒", ["There are three childrens in the garden.", "There are three childs in the garden."]),
        s(.plurals, "The mice are under the bed.", "Los ratones están debajo de la cama.", "🐭", ["The mouses are under the bed.", "The mice is under the bed."]),
        s(.plurals, "Those men are very tall.", "Esos hombres son muy altos.", "🧍", ["Those mans are very tall.", "That men are very tall."]),
    ]

    // MARK: - El Mandón: modal verbs

    static let bossy: [Card] = [
        s(.bossy, "I must do my homework.", "Tengo que hacer los deberes.", "📝", ["I must to do my homework.", "I must doing my homework."], tip: "Detrás de must el verbo va solo, sin to."),
        s(.bossy, "You mustn't run in the classroom.", "No debes correr en clase.", "🚫", ["You no must run in the classroom.", "You mustn't to run in the classroom."], tip: "No debes = mustn't."),
        s(.bossy, "She has to wear a uniform.", "Ella tiene que llevar uniforme.", "👔", ["She have to wear a uniform.", "She has to wears a uniform."], tip: "Si es él o ella, se dice has to. Y el verbo de detrás va sin s."),
        s(.bossy, "I can swim.", "Sé nadar.", "🏊", ["I can to swim.", "I can swimming."], tip: "Detrás de can, el verbo va solo: I can swim."),
        s(.bossy, "Can you play the guitar?", "¿Sabes tocar la guitarra?", "🎸", ["Do you can play the guitar?", "You can play the guitar?"], tip: "Pregunta con can: salta can, sin do: Can you…?"),
        s(.bossy, "He can't ride a horse.", "Él no sabe montar a caballo.", "🐴", ["He can't to ride a horse.", "He no can ride a horse."]),
        s(.bossy, "Shall I open the window?", "¿Abro la ventana?", "🪟", ["Shall I to open the window?", "I open the window?"], tip: "Para ofrecer ayuda, ¿lo hago yo?, se dice Shall I…?"),
        s(.bossy, "We have to go now.", "Tenemos que irnos ya.", "🏃", ["We have go now.", "We must to go now."]),
        s(.bossy, "Do you have to get up early?", "¿Tienes que levantarte pronto?", "⏰", ["Have you to get up early?", "You have to get up early?"]),
        s(.bossy, "I could swim when I was five.", "Sabía nadar cuando tenía cinco años.", "🧒", ["I could to swim when I was five.", "I can swim when I was five."], tip: "could quiere decir podía o sabía."),
        s(.bossy, "Could you help me, please?", "¿Me podrías ayudar, por favor?", "🙏", ["Could you to help me, please?", "You could help me, please?"]),
        s(.bossy, "She doesn't have to go to school on Saturdays.", "Ella no tiene que ir al colegio los sábados.", "🛌", ["She doesn't has to go to school on Saturdays.", "She hasn't to go to school on Saturdays."]),
        s(.bossy, "You must be quiet in the library.", "Debes estar en silencio en la biblioteca.", "🤫", ["You must to be quiet in the library.", "You must are quiet in the library."]),
        s(.bossy, "Shall we play a game?", "¿Jugamos a algo?", "🎲", ["Shall we to play a game?", "We play a game?"]),
        s(.bossy, "Tom can play chess very well.", "Tom sabe jugar muy bien al ajedrez.", "♟️", ["Tom cans play chess very well.", "Tom can plays chess very well."], tip: "can nunca lleva s, y el verbo de detrás tampoco: Tom can play."),
    ]

    // MARK: - Caracol Adverbio: adverbs

    static let snail: [Card] = [
        s(.snail, "She sings very well.", "Ella canta muy bien.", "🎤", ["She sings very good.", "She sing very well."], tip: "Cantar bien = sing WELL. good es para cosas: a good song."),
        s(.snail, "He runs quickly.", "Él corre rápido.", "🏃", ["He runs quick.", "He runs quickely."]),
        s(.snail, "The tortoise walks slowly.", "La tortuga anda despacio.", "🐢", ["The tortoise walks slow.", "The tortoise walks slowley."]),
        s(.snail, "Please talk quietly.", "Por favor, habla bajito.", "🤫", ["Please talk quiet.", "Please talk quietely."]),
        s(.snail, "The baby is laughing happily.", "El bebé se ríe feliz.", "👶", ["The baby is laughing happy.", "The baby is laughing happyly."], tip: "happy → happily: la y cambia a i."),
        s(.snail, "Write your name carefully.", "Escribe tu nombre con cuidado.", "✍️", ["Write your name careful.", "Write your name carefuly."], tip: "careful + ly = carefully, con dos l."),
        s(.snail, "My team played badly.", "Mi equipo jugó mal.", "😞", ["My team played bad.", "My team played badely."]),
        s(.snail, "The dog barks loudly.", "El perro ladra fuerte.", "🐕", ["The dog barks loud.", "The dog barks loudy."]),
        s(.snail, "You did it well!", "¡Lo has hecho bien!", "🌟", ["You did it good!", "You did good it!"]),
        s(.snail, "She is a good singer.", "Ella es una buena cantante.", "👩‍🎤", ["She is a well singer.", "She is a singer good."], tip: "Para decir cómo ES alguien: good. a good singer."),
        s(.snail, "He runs fast.", "Él corre rápido.", "💨", ["He runs fastly.", "He run fast."], tip: "fast es rebelde: no cambia. He runs fast."),
        s(.snail, "They climbed the tree easily.", "Treparon al árbol fácilmente.", "🌳", ["They climbed the tree easy.", "They climbed the tree easyly."]),
        s(.snail, "Tom answered the question correctly.", "Tom respondió bien a la pregunta.", "✅", ["Tom answered the question correct.", "Tom answered correctly the question."]),
        s(.snail, "The children are playing nicely.", "Los niños están jugando bien.", "🧸", ["The children are playing nice.", "The children are playing nicelly."]),
        s(.snail, "It is raining heavily.", "Está lloviendo mucho.", "⛈️", ["It is raining heavy.", "It is raining heavyly."]),
        w(.snail, "quickly", "rápidamente", "🐇", ["quikly", "quickely"]),
        w(.snail, "slowly", "despacio", "🐌", ["slowley", "slowli"]),
        w(.snail, "carefully", "con cuidado", "🧐", ["carefuly", "carfully"]),
        w(.snail, "happily", "felizmente", "😊", ["happyly", "happly"]),
    ]

    // MARK: - El Pegamento: who, which, where, because

    static let linker: [Card] = [
        s(.linker, "The man who lives next door is a doctor.", "El señor que vive al lado es médico.", "🩺", ["The man which lives next door is a doctor.", "The man who he lives next door is a doctor."], tip: "Para personas, who. ¡Y sin repetir he! Se dice who lives."),
        s(.linker, "This is the park where we play.", "Este es el parque donde jugamos.", "🛝", ["This is the park where we play in.", "This is the park which we play."], tip: "Para sitios, where."),
        s(.linker, "I have got a dog which is very funny.", "Tengo un perro que es muy gracioso.", "🐶", ["I have got a dog who it is very funny.", "I have got a dog which it is very funny."], tip: "Para cosas y animales, which. ¡Y sin repetir it!"),
        s(.linker, "She is the girl who sings in the band.", "Ella es la niña que canta en el grupo.", "🎤", ["She is the girl which sings in the band.", "She is the girl who she sings in the band."]),
        s(.linker, "I am happy because it is my birthday.", "Estoy contento porque es mi cumpleaños.", "🎂", ["I am happy because is my birthday.", "I am happy becose it is my birthday."], tip: "Detrás de because hace falta quién: because IT is."),
        s(.linker, "That is the shop where I buy comics.", "Esa es la tienda donde compro cómics.", "📕", ["That is the shop where I buy comics there.", "That is the shop who I buy comics."]),
        s(.linker, "A penguin is a bird which can't fly.", "El pingüino es un pájaro que no puede volar.", "🐧", ["A penguin is a bird who can't fly.", "A penguin is a bird which no can fly."]),
        s(.linker, "I can't go out because I am ill.", "No puedo salir porque estoy enfermo.", "🤒", ["I can't go out because am ill.", "I no can go out because I am ill."]),
        s(.linker, "The boy who is wearing a cap is my cousin.", "El niño que lleva gorra es mi primo.", "🧢", ["The boy which is wearing a cap is my cousin.", "The boy who he is wearing a cap is my cousin."]),
        s(.linker, "I like books which have got pictures.", "Me gustan los libros que tienen dibujos.", "📚", ["I like books who have got pictures.", "I like books which they have got pictures."]),
        s(.linker, "When it rains, we play inside.", "Cuando llueve, jugamos dentro.", "🌧️", ["When rains, we play inside.", "When it rain, we play inside."], tip: "Cuando llueve = when IT rains. En inglés hace falta it."),
        s(.linker, "This is the house where my grandma lives.", "Esta es la casa donde vive mi abuela.", "🏠", ["This is the house where lives my grandma.", "This is the house which my grandma lives."], tip: "Detrás de where va quién y luego el verbo: where my grandma lives."),
        s(.linker, "I went to bed early because I was tired.", "Me fui pronto a la cama porque estaba cansado.", "😴", ["I went to bed early because was tired.", "I went to bed early because I were tired."]),
        s(.linker, "I like apples but I don't like bananas.", "Me gustan las manzanas pero no los plátanos.", "🍎", ["I like apples but I no like bananas.", "I like apples but I doesn't like bananas."]),
        s(.linker, "A pilot is a person who flies planes.", "Un piloto es una persona que pilota aviones.", "🧑‍✈️", ["A pilot is a person which flies planes.", "A pilot is a person who fly planes."]),
    ]

    // MARK: - Vocabulary

    static let moversVocabulary: [Card] = animals + body + clothes + family + food + home + school
        + sports + town + nature + transport + time + jobs + numbers + feelings

    static let animals: [Card] = [
        w(.animals, "bat", "murciélago", "🦇", ["batt", "bad"]),
        w(.animals, "bear", "oso", "🐻", ["ber", "beer"], tip: "bear = oso. beer = cerveza 🍺."),
        w(.animals, "dolphin", "delfín", "🐬", ["dolfin", "dolphine"], tip: "ph suena f: dol-PH-in."),
        w(.animals, "kangaroo", "canguro", "🦘", ["cangaroo", "kangaru"]),
        w(.animals, "kitten", "gatito", "🐱", ["kiten", "kittin"]),
        w(.animals, "lion", "león", "🦁", ["laion", "leon"]),
        w(.animals, "giraffe", "jirafa", "🦒", ["jiraf", "girafe"]),
        w(.animals, "parrot", "loro", "🦜", ["parot", "perrot"]),
        w(.animals, "penguin", "pingüino", "🐧", ["pinguin", "penguine"]),
        w(.animals, "puppy", "cachorro", "🐶", ["pupy", "papi"]),
        w(.animals, "shark", "tiburón", "🦈", ["shak", "sharck"]),
        w(.animals, "snail", "caracol", "🐌", ["sneil", "snayl"]),
        w(.animals, "whale", "ballena", "🐋", ["wale", "gueil"], tip: "whale lleva una h escondida: w-H-ale."),
        w(.animals, "monkey", "mono", "🐒", ["monky", "mankey"]),
        w(.animals, "rabbit", "conejo", "🐰", ["rabit", "rabbitt"]),
    ]

    static let body: [Card] = [
        w(.body, "shoulder", "hombro", "🤷", ["sholder", "shoulda"]),
        w(.body, "stomach", "estómago, barriga", "🫃", ["stomak", "estomach"], tip: "stomach: la ch suena k. Y sin e delante."),
        w(.body, "knee", "rodilla", "🦵", ["nee", "kne"], tip: "knee empieza por una k que no suena."),
        w(.body, "neck", "cuello", "🧣", ["nek", "neckk"]),
        w(.body, "back", "espalda", "🔙", ["bak", "bac"]),
        w(.body, "teeth", "dientes", "🦷", ["tiz", "teez"], tip: "tooth = un diente. teeth = dientes."),
        w(.body, "headache", "dolor de cabeza", "🤕", ["hedeik", "headeake"]),
        w(.body, "earache", "dolor de oídos", "👂", ["ireik", "earake"]),
        w(.body, "toothache", "dolor de muelas", "😬", ["tuzeik", "toothake"]),
        w(.body, "stomach-ache", "dolor de barriga", "🤢", ["stomakeik", "stomach ake"]),
        w(.body, "cough", "tos", "😷", ["cof", "kough"], tip: "cough suena «cof» pero se escribe c-o-u-g-h."),
        w(.body, "cold", "resfriado", "🤧", ["cowld", "coold"]),
        w(.body, "temperature", "fiebre, temperatura", "🌡️", ["temperatur", "tempreture"]),
        w(.body, "medicine", "medicina", "💊", ["medisin", "medecine"]),
        w(.body, "ill", "enfermo", "🤒", ["il", "yll"]),
    ]

    static let clothes: [Card] = [
        w(.clothes, "jacket", "chaqueta", "🧥", ["yaket", "jaket"]),
        w(.clothes, "scarf", "bufanda", "🧣", ["escarf", "scarff"]),
        w(.clothes, "sweater", "jersey", "🧶", ["sueter", "sweter"]),
        w(.clothes, "helmet", "casco", "⛑️", ["jelmet", "helmit"]),
        w(.clothes, "glasses", "gafas", "👓", ["glases", "glasess"]),
        w(.clothes, "trousers", "pantalones", "👖", ["trausers", "trowsers"]),
        w(.clothes, "shorts", "pantalones cortos", "🩳", ["chorts", "shorst"]),
        w(.clothes, "socks", "calcetines", "🧦", ["soks", "sox"]),
        w(.clothes, "shoes", "zapatos", "👞", ["shus", "shoos"]),
        w(.clothes, "skirt", "falda", "💃", ["eskirt", "skert"]),
        w(.clothes, "shirt", "camisa", "👔", ["shert", "chirt"]),
        w(.clothes, "dress", "vestido", "👗", ["dres", "dresse"]),
        w(.clothes, "T-shirt", "camiseta", "👕", ["ti shirt", "tishert"]),
        w(.clothes, "pocket", "bolsillo", "👛", ["poket", "pockit"]),
        w(.clothes, "coat", "abrigo", "🧥", ["cot", "kout"]),
    ]

    static let family: [Card] = [
        w(.family, "aunt", "tía", "👩", ["ant", "arnt"], tip: "aunt = tía. ant = hormiga 🐜."),
        w(.family, "uncle", "tío", "👨", ["ankel", "uncel"]),
        w(.family, "cousin", "primo, prima", "🧒", ["cosin", "causin"]),
        w(.family, "grandparents", "abuelos", "👵", ["granparents", "grandparens"]),
        w(.family, "grandson", "nieto", "👦", ["granson", "grandsun"]),
        w(.family, "granddaughter", "nieta", "👧", ["grandaughter", "granddoter"]),
        w(.family, "parents", "padres", "👫", ["parens", "perents"]),
        w(.family, "daughter", "hija", "👧", ["dauter", "doughter"], tip: "daughter tiene gh que no suena."),
        w(.family, "son", "hijo", "👦", ["sun", "sonn"], tip: "son = hijo. sun = sol ☀️."),
        w(.family, "baby", "bebé", "👶", ["beibi", "babie"]),
        w(.family, "brother", "hermano", "🧑", ["broder", "brather"]),
        w(.family, "sister", "hermana", "👩", ["sistar", "sester"]),
        w(.family, "grandmother", "abuela", "👵", ["granmother", "grandmather"]),
        w(.family, "grandfather", "abuelo", "👴", ["granfather", "grandfader"]),
        w(.family, "people", "gente", "👥", ["pipol", "peopel"]),
    ]

    static let food: [Card] = [
        w(.food, "bottle", "botella", "🍾", ["botel", "botle"]),
        w(.food, "bowl", "cuenco", "🥣", ["boul", "bol"]),
        w(.food, "cheese", "queso", "🧀", ["chis", "chesse"]),
        w(.food, "coffee", "café", "☕", ["cofee", "coffe"]),
        w(.food, "cup", "taza", "🍵", ["cap", "kup"]),
        w(.food, "milkshake", "batido", "🥤", ["milkshak", "milshake"]),
        w(.food, "noodles", "fideos", "🍜", ["nudels", "noodels"]),
        w(.food, "pancake", "tortita", "🥞", ["pankeik", "pancak"]),
        w(.food, "salad", "ensalada", "🥗", ["salat", "salada"]),
        w(.food, "sandwich", "sándwich", "🥪", ["sanwich", "sandwitch"]),
        w(.food, "sauce", "salsa", "🥫", ["sause", "sos"]),
        w(.food, "tea", "té", "🫖", ["ti", "tee"]),
        w(.food, "vegetables", "verduras", "🥦", ["vegetabels", "vejetables"]),
        w(.food, "biscuit", "galleta", "🍪", ["biskit", "bisquit"]),
        w(.food, "strawberry", "fresa", "🍓", ["strawbery", "straberry"]),
    ]

    static let home: [Card] = [
        w(.home, "balcony", "balcón", "🏙️", ["balcon", "balkony"]),
        w(.home, "basement", "sótano", "🏚️", ["basment", "beisment"]),
        w(.home, "downstairs", "abajo (en casa)", "⬇️", ["dawnstairs", "downsteirs"]),
        w(.home, "upstairs", "arriba (en casa)", "⬆️", ["apstairs", "upsteirs"]),
        w(.home, "floor", "suelo", "🟫", ["flor", "floore"]),
        w(.home, "roof", "tejado", "🏠", ["ruf", "rooff"]),
        w(.home, "shower", "ducha", "🚿", ["shauer", "chower"]),
        w(.home, "towel", "toalla", "🛁", ["tauel", "towell"]),
        w(.home, "toothbrush", "cepillo de dientes", "🪥", ["tuthbrush", "toothbrus"]),
        w(.home, "toothpaste", "pasta de dientes", "🦷", ["toothpeist", "tuthpaste"]),
        w(.home, "kitchen", "cocina", "🍳", ["kitchin", "kichen"]),
        w(.home, "bathroom", "baño", "🛀", ["bazroom", "bathrum"]),
        w(.home, "bedroom", "dormitorio", "🛏️", ["bedrum", "bedrom"]),
        w(.home, "garden", "jardín", "🌷", ["garten", "gardin"]),
        w(.home, "stairs", "escaleras", "🪜", ["esteirs", "stears"]),
    ]

    static let school: [Card] = [
        w(.school, "homework", "deberes", "📝", ["jomwork", "homewerk"]),
        w(.school, "classroom", "aula, clase", "🏫", ["clasroom", "classrum"]),
        w(.school, "comic", "cómic", "📕", ["comik", "commic"]),
        w(.school, "email", "correo electrónico", "📧", ["imeil", "emeil"]),
        w(.school, "film", "película", "🎬", ["filme", "flim"]),
        w(.school, "hobby", "afición", "🎨", ["jobby", "hoby"]),
        w(.school, "internet", "internet", "🌐", ["internete", "interned"]),
        w(.school, "music", "música", "🎵", ["musik", "miusic"]),
        w(.school, "party", "fiesta", "🎉", ["parti", "partty"]),
        w(.school, "picnic", "picnic", "🧺", ["picnik", "pic nic"]),
        w(.school, "quiz", "concurso de preguntas", "❓", ["kwiz", "quis"]),
        w(.school, "crayon", "cera de colores", "🖍️", ["creyon", "crayion"]),
        w(.school, "pencil", "lápiz", "✏️", ["pensil", "pencel"]),
        w(.school, "ruler", "regla", "📏", ["ruller", "rular"]),
        w(.school, "dictionary", "diccionario", "📖", ["diccionary", "dictionari"]),
    ]

    static let sports: [Card] = [
        w(.sports, "basketball", "baloncesto", "🏀", ["basketbol", "basket ball"]),
        w(.sports, "badminton", "bádminton", "🏸", ["badmington", "badmindon"]),
        w(.sports, "baseball", "béisbol", "⚾", ["beisbol", "basebol"]),
        w(.sports, "football", "fútbol", "⚽", ["futbol", "footbal"]),
        w(.sports, "hockey", "hockey", "🏑", ["jockey", "hokey"]),
        w(.sports, "tennis", "tenis", "🎾", ["tenis", "tennies"]),
        w(.sports, "swimming", "natación", "🏊", ["swiming", "suimming"]),
        w(.sports, "skating", "patinaje", "⛸️", ["eskating", "skateing"]),
        w(.sports, "climbing", "escalada", "🧗", ["climing", "claimbing"], tip: "climb tiene una b que no suena: clim-B-ing."),
        w(.sports, "sailing", "vela", "⛵", ["seiling", "saling"]),
        w(.sports, "fishing", "pesca", "🎣", ["fising", "fishin"]),
        w(.sports, "goal", "gol, portería", "🥅", ["gol", "goul"]),
        w(.sports, "team", "equipo", "🏆", ["tim", "teem"]),
        w(.sports, "race", "carrera", "🏁", ["reis", "rays"]),
        w(.sports, "player", "jugador, jugadora", "🏃", ["pleyer", "plaier"]),
    ]

    static let town: [Card] = [
        w(.town, "bank", "banco", "🏦", ["benk", "banck"]),
        w(.town, "bus station", "estación de autobuses", "🚏", ["bus estation", "bus staition"]),
        w(.town, "car park", "aparcamiento", "🅿️", ["car parck", "kar park"]),
        w(.town, "circus", "circo", "🎪", ["sircus", "circos"]),
        w(.town, "city", "ciudad", "🏙️", ["siti", "citty"]),
        w(.town, "hospital", "hospital", "🏥", ["ospital", "hospitall"]),
        w(.town, "library", "biblioteca", "📚", ["libery", "librery"], tip: "library = biblioteca. ¡No es librería (bookshop)!"),
        w(.town, "market", "mercado", "🧺", ["marquet", "markit"]),
        w(.town, "playground", "parque infantil, patio", "🛝", ["pleiground", "play ground"]),
        w(.town, "square", "plaza", "⛲", ["skuer", "squere"]),
        w(.town, "sports centre", "polideportivo", "🏟️", ["sport centre", "sports sentre"]),
        w(.town, "supermarket", "supermercado", "🛒", ["supermarquet", "super market"]),
        w(.town, "swimming pool", "piscina", "🩱", ["swiming pool", "swimming pul"]),
        w(.town, "street", "calle", "🛣️", ["estreet", "strit"]),
        w(.town, "cinema", "cine", "🎦", ["sinema", "cinemma"]),
    ]

    static let nature: [Card] = [
        w(.nature, "cloud", "nube", "☁️", ["claud", "clowd"]),
        w(.nature, "cloudy", "nublado", "🌥️", ["claudy", "clowdy"]),
        w(.nature, "rainbow", "arcoíris", "🌈", ["reinbow", "rainbou"]),
        w(.nature, "sunny", "soleado", "☀️", ["suny", "sanny"]),
        w(.nature, "windy", "ventoso", "💨", ["windi", "wendy"]),
        w(.nature, "rain", "lluvia", "🌧️", ["rein", "rane"]),
        w(.nature, "snow", "nieve", "❄️", ["snou", "esnow"]),
        w(.nature, "weather", "el tiempo (que hace)", "🌦️", ["wether", "weader"]),
        w(.nature, "forest", "bosque", "🌲", ["forrest", "foresst"]),
        w(.nature, "island", "isla", "🏝️", ["ailand", "iland"], tip: "island tiene una s que no suena: i-S-land."),
        w(.nature, "lake", "lago", "🏞️", ["leik", "laik"]),
        w(.nature, "mountain", "montaña", "⛰️", ["mountin", "mauntain"]),
        w(.nature, "river", "río", "🌊", ["rivar", "riber"]),
        w(.nature, "field", "campo", "🌾", ["fild", "feeld"]),
        w(.nature, "waterfall", "cascada", "💦", ["woterfall", "waterfol"]),
    ]

    static let transport: [Card] = [
        w(.transport, "motorbike", "moto", "🏍️", ["motorbaik", "motor bike"]),
        w(.transport, "helicopter", "helicóptero", "🚁", ["elicopter", "helicoptor"]),
        w(.transport, "plane", "avión", "✈️", ["plein", "plain"]),
        w(.transport, "ship", "barco", "🚢", ["chip", "sheep"], tip: "ship = barco. sheep = oveja 🐑."),
        w(.transport, "boat", "barca", "🚤", ["bout", "bot"]),
        w(.transport, "train", "tren", "🚆", ["trein", "tren"]),
        w(.transport, "lorry", "camión", "🚚", ["lori", "lorri"]),
        w(.transport, "bike", "bici", "🚲", ["baik", "bik"]),
        w(.transport, "taxi", "taxi", "🚕", ["taksi", "taxy"]),
        w(.transport, "tractor", "tractor", "🚜", ["tracktor", "tractour"]),
        w(.transport, "ticket", "billete", "🎫", ["tiket", "tickit"]),
        w(.transport, "bus stop", "parada de autobús", "🚌", ["bus estop", "bas stop"]),
        w(.transport, "airport", "aeropuerto", "🛫", ["airpot", "eirport"]),
        w(.transport, "rocket", "cohete", "🚀", ["roket", "rocquet"]),
        w(.transport, "wheel", "rueda", "🛞", ["wil", "weel"]),
    ]

    static let time: [Card] = [
        w(.time, "Monday", "lunes", "🗓️", ["monday", "Mondey"], tip: "Los días van siempre con mayúscula: Monday."),
        w(.time, "Tuesday", "martes", "🗓️", ["Tusday", "Teusday"]),
        w(.time, "Friday", "viernes", "🗓️", ["Fraiday", "friday"]),
        w(.time, "Saturday", "sábado", "🗓️", ["Saturdei", "Saterday"]),
        w(.time, "Sunday", "domingo", "🗓️", ["Sanday", "sunday"]),
        w(.time, "weekend", "fin de semana", "🛌", ["wikend", "week end"]),
        w(.time, "week", "semana", "📆", ["wik", "weak"]),
        w(.time, "today", "hoy", "📍", ["tuday", "todey"]),
        w(.time, "tomorrow", "mañana (el día siguiente)", "⏭️", ["tomorow", "tommorrow"]),
        w(.time, "yesterday", "ayer", "⏮️", ["yesterdey", "jesterday"]),
        w(.time, "morning", "la mañana", "🌅", ["mornin", "mourning"]),
        w(.time, "afternoon", "la tarde", "🌤️", ["afternun", "after noon"]),
        w(.time, "evening", "la tarde-noche", "🌆", ["ivening", "evenin"]),
        w(.time, "night", "noche", "🌙", ["nait", "nigth"]),
        w(.time, "birthday", "cumpleaños", "🎂", ["berthday", "birday"]),
    ]

    static let jobs: [Card] = [
        w(.jobs, "doctor", "médico, médica", "🩺", ["docter", "doktor"]),
        w(.jobs, "dentist", "dentista", "🦷", ["dentis", "dentista"]),
        w(.jobs, "nurse", "enfermero, enfermera", "👩‍⚕️", ["nurs", "ners"]),
        w(.jobs, "farmer", "granjero, granjera", "👩‍🌾", ["farmar", "famer"]),
        w(.jobs, "cook", "cocinero, cocinera", "🧑‍🍳", ["cuk", "coock"]),
        w(.jobs, "waiter", "camarero", "🤵", ["weiter", "waitor"]),
        w(.jobs, "driver", "conductor, conductora", "🚗", ["draiver", "drivar"]),
        w(.jobs, "teacher", "profesor, profesora", "🧑‍🏫", ["ticher", "teatcher"]),
        w(.jobs, "singer", "cantante", "🎤", ["singar", "senger"]),
        w(.jobs, "clown", "payaso", "🤡", ["claun", "clawn"]),
        w(.jobs, "pop star", "estrella del pop", "🌟", ["pop estar", "pop starr"]),
        w(.jobs, "police officer", "policía", "👮", ["polis officer", "police oficer"]),
        w(.jobs, "firefighter", "bombero, bombera", "🧑‍🚒", ["fairfaiter", "fire fighter"]),
        w(.jobs, "vet", "veterinario, veterinaria", "🐾", ["bet", "vett"]),
        w(.jobs, "pilot", "piloto", "🧑‍✈️", ["pailot", "pilote"]),
    ]

    static let numbers: [Card] = [
        w(.numbers, "twenty", "veinte", "20", ["tweny", "twenti"]),
        w(.numbers, "thirty", "treinta", "30", ["therty", "thirdy"]),
        w(.numbers, "forty", "cuarenta", "40", ["fourty", "forti"], tip: "forty se escribe SIN u, aunque four la lleve."),
        w(.numbers, "fifty", "cincuenta", "50", ["fivety", "fifti"]),
        w(.numbers, "sixty", "sesenta", "60", ["sixti", "sixtee"]),
        w(.numbers, "seventy", "setenta", "70", ["seventi", "sevendy"]),
        w(.numbers, "eighty", "ochenta", "80", ["eigty", "eity"]),
        w(.numbers, "ninety", "noventa", "90", ["ninty", "nainty"], tip: "ninety conserva la e de nine: nin-E-ty."),
        w(.numbers, "one hundred", "cien", "💯", ["one houndred", "one hundret"]),
        w(.numbers, "twenty-five", "veinticinco", "25", ["twentyfive", "twenty-fiv"], tip: "Números como twenty-five llevan una rayita en medio."),
        w(.numbers, "thirty-three", "treinta y tres", "33", ["therty-three", "thirty-tree"]),
        w(.numbers, "first", "primero", "🥇", ["ferst", "fist"]),
        w(.numbers, "second", "segundo", "🥈", ["secund", "seccond"]),
        w(.numbers, "third", "tercero", "🥉", ["therd", "thirt"]),
        w(.numbers, "twelfth", "duodécimo", "12º", ["twelveth", "twelth"]),
    ]

    static let feelings: [Card] = [
        w(.feelings, "angry", "enfadado", "😠", ["angri", "hangry"]),
        w(.feelings, "bored", "aburrido", "🥱", ["bord", "boared"]),
        w(.feelings, "hungry", "con hambre", "😋", ["hangry", "hungri"]),
        w(.feelings, "thirsty", "con sed", "🥤", ["thersty", "tirsty"]),
        w(.feelings, "tired", "cansado", "😴", ["taired", "tiered"]),
        w(.feelings, "scared", "asustado", "😱", ["escared", "skared"]),
        w(.feelings, "excited", "emocionado", "🤩", ["exited", "exsited"]),
        w(.feelings, "weak", "débil", "🥀", ["wik", "week"]),
        w(.feelings, "strong", "fuerte", "💪", ["estrong", "strang"]),
        w(.feelings, "quiet", "silencioso, tranquilo", "🤫", ["quite", "kwaiet"], tip: "quiet (silencioso) ≠ quite (bastante)."),
        w(.feelings, "loud", "ruidoso", "📢", ["laud", "lowd"]),
        w(.feelings, "dirty", "sucio", "🐷", ["derty", "dirti"]),
        w(.feelings, "beautiful", "precioso", "🌸", ["beautifull", "biutiful"]),
        w(.feelings, "different", "diferente", "🔀", ["diferent", "diffrent"]),
        w(.feelings, "delicious", "delicioso", "🍰", ["delicius", "delishious"]),
    ]
}
