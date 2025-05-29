object juego {
  // definimos personajes
  var personajes = [new Amigo(), new Amigo(), new Amigo(), new Amigo(),new Amigo(),new Amigo(),new Amigo(),new Amigo(),new Amigo(),
                    new Enemigo(), new Enemigo(), new Enemigo(), new Enemigo(), new Enemigo(), new Enemigo()]
  var amigos = personajes.filter {personaje => personaje.tipo() == "Amigo"}
  var enemigos = personajes.filter {personaje => personaje.tipo() == "Enemigo"}
  var nivel = 1
  method amigos() = amigos
  method enemigos() = enemigos
  method personajes() = personajes
  method gameOver() = jugador.vidas() == 0
  method ganar() = jugador.amigosRescatados() == amigos.size()

  method iniciar() {

    // añadimos la interfaz
    game.addVisual(vidasRestantes)
    game.addVisual(amigosRescatados)
    game.addVisual(puntosConseguidos)

    // añadimos personajes
    game.addVisualCharacter(jugador)
    game.say(jugador, "Tengo que salvar a mis amigos pulsando ESPACIO")
    personajes.forEach {personaje => game.addVisual(personaje)}
    
    // definimos su movimiento
    game.onTick(750, "movimiento", {personajes.forEach { personaje => personaje.moverse()}})

    // para salvar un amigo al estar sobre el y presionar ESPACIO
    keyboard.space().onPressDo {
      var amigoEncontrado = amigos.find { amigo => 
        	amigo.position() == jugador.position()
    	}
    	if (amigoEncontrado != null) {
        	game.say(jugador, "Gracias!")
          game.removeVisual(amigoEncontrado)
          jugador.rescatarAmigo()
    	}
      if (self.ganar()) {
        // nivel += 1
        // if (nivel == 2) {
        //   game.say(jugador, "Nivel 2")
        //   personajes = [new Amigo(), new Amigo(), new Amigo(), new Amigo(), new Amigo(), new Amigo(),
        //                 new Enemigo(), new Enemigo()]
        //   personajes.forEach {personaje => game.addVisual(personaje)}
        // }
        // if (nivel == 3) {
        //   game.say(jugador, "Nivel 3")
        //   personajes = [new Amigo(), new Amigo(), new Amigo(), new Amigo(), new Amigo(), new Amigo(), new Amigo(), new Amigo(), new Amigo(),
        //                 new Enemigo(), new Enemigo(), new Enemigo()]
        // }
        // if (nivel == 4) {
        //   game.addVisual(ganaste)
        //   game.removeVisual(jugador)
        // }
        game.addVisual(ganaste)
        game.removeVisual(jugador)
      }
    }

    // para que un enemigo mate al jugador al tocarlo
    game.onCollideDo(jugador, { enemigo =>
      enemigo.matarJugador()
      jugador.reiniciarPosicion()
      game.say(enemigo, "JAJAJAJA...")

    // Por si perdemos
    if (self.gameOver()) {
      const gamerOver = new Texto(texto = "GAME OVER", color="FF0000FF")
      // borro el reiniciar porque no se el comando para reiniciar un
      // const reiniciar = new Texto(texto = "Pulsa R para reiniciar", color ="#646464", posicion = game.at(7, 3))
      game.addVisual(gameOver)
      game.removeVisual(jugador)
    }
      }
    )
  }
}

object jugador {
  var property position = game.origin()
  var property image = "jugador.png"

  var amigosRescatados = 0
  var vidas = 3
  var puntos = 0

  method amigosRescatados() = amigosRescatados
  method vidas() = vidas
  method puntos() = puntos

  method rescatarAmigo() {
    amigosRescatados += 1
    puntos += 250
  }
  method morir() {
    vidas = (vidas - 1).max(0)
    puntos = (puntos - 400).max(0)
  }
  method reiniciarPosicion() {
    position = game.origin()
  }
}

class Amigo {
  const x = 0.randomUpTo(game.width()).truncate(0)
  const y = 0.randomUpTo(game.height()).truncate(0)
  var property position = game.at(x, y)
  var property image = "amigo.png"
  method tipo() = "Amigo"

  method moverse() {
    var movimiento = [position.up(1), position.down(1), position.right(1), position.left(1)].anyOne()
    if (movimiento.x().between(0, game.width() - 1) and movimiento.y().between(0, game.height() - 1)) {
      position = movimiento
    }
  }
}

class Enemigo {
  const x = 0.randomUpTo(game.width()).truncate(0)
  const y = 0.randomUpTo(game.height()).truncate(0)
  var property position = game.at(x, y)
  var property image = "enemigo.png"
  method tipo() = "Enemigo"

  method moverse() {
    var movimiento = [position.up(1), position.down(1), position.right(1), position.left(1)].anyOne()
    if (movimiento.x().between(0, game.width() - 1) and movimiento.y().between(0, game.height() - 1)) {
      position = movimiento
    }
  }
  
  method matarJugador() {
    jugador.morir()
  }
}

// definimos interfaces
class Texto {
  var posicion = game.center()
  var color
  var texto
  var property position = posicion
  var property textColor = color
  method text() = texto
}

object vidasRestantes {
  var property position = game.at(2, 8)
  method text() = "Vidas: " + jugador.vidas()
  var property textColor = "#646464"
}
object amigosRescatados {
  var property position = game.at(5, 8)
  method text() = "Rescatados: " + jugador.amigosRescatados() + "/" + juego.amigos().size()
  var property textColor = "#646464"
}

object puntosConseguidos {
  var property position = game.at(7, 8)
  method text() = "Puntos: " + jugador.puntos()
  var property textColor = "#646464"
}

object gameOver {
  var property position = game.center()
  var property text= "GAME OVER"
  var property textColor = "FF0000FF"
}

object ganaste {
  var property position = game.center()
  var property text= "Ganaste!"
  var property textColor = "00FF00FF"
}
