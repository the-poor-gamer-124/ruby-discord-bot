module Discord
  module FunCommands
    extend Discordrb::Commands::CommandContainer

    QUOTES = [
      "Yo no negocio ni converso con terroristas que han incendiado y quemado iglesias, casas y personas",
      "Las fuerzas armadas no usaron la fuerza para tomarse el poder, sino para recuperar Chile",
      "Si yo pido colaboración a las Fuerzas Armadas es para alcanzar paz en una zona que no hay paz",
      "Soy un fenómeno electoral. Así como voy, voy a terminar en 55% porque voy subiendo cinco puntos por mes",
      "Si yo fuera homosexual, sería casto",
      "Yo no soy pinochetista, no tengo una foto de Pinochet en mi casa",
      "No salvo nada de este gobierno. El Puente Cau Cau queda chico al lado del despilfarro que es el Transantiago",
      "El cierre de Punta Peuco es una excusa para tapar el desastre económico",
      "Creo que crear un canal de television para esta comunidad es una idea digna de un genio"
    ]

    desc = "Cita al azar de J. A. Kast"
    command :quote, description: desc do |event|
      event.respond QUOTES.sample
    end

    desc = "Cachetea a J. A. Kast"
    command :smack, description: desc do |event|
      event.respond "Te voy a demandar, peliento periferico poblacional!"
    end
  end
end
