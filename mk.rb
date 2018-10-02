require 'singleton'

class Luchador
  attr_accessor :vida, :bloqueando

  def initialize(vida = 100)
    self.vida = vida
  end

  def atacar(otro_luchador)
    otro_luchador.recibir_ataque(5)
  end

  def recibir_ataque(danio)
    recibir_danio(danio) unless bloqueando
  end

  def recibir_danio(danio)
    self.vida -= danio
  end

  def atacar_a_todos(luchadores)
    luchadores.each do |enemigo|
      atacar(enemigo)
    end
  end
end

class Kitana < Luchador
  def tirar_abanico(otro_luchador)
    otro_luchador.recibir_danio(10)
  end
end

class LuchadorNovato < Luchador
  def metodo_al_azar(argumento)
    metodo_a_ejecutar = metodos_de_un_argumento(true).sample
    puts 'Ejecutando ' + metodo_a_ejecutar.to_s
    send(metodo_a_ejecutar, argumento)
  end
end

class Object
  def metodos_de_un_argumento(incluyendo_heredados = false)
    (public_methods incluyendo_heredados).select do |metodo|
      method(metodo).arity == 1
    end
  end
end

class ShangTsung < Luchador
  include Singleton

  # define_method es privado porque si no seria un caos
  def self.aprender_ataque(nombre, metodo)
    define_method(nombre, metodo)
  end

  def robar_ataques(otro_luchador)
    metodos_a_robar = otro_luchador.public_methods(false)
    puts 'Robando ' + metodos_a_robar.inspect
    metodos_a_robar.each do |ataque|
      # otro_luchador.method(ataque) devuelve un Method, un bloque bindeado
      metodo_bindeado = otro_luchador.method(ataque).to_proc
      puts ataque.to_s
      self.class.aprender_ataque(ataque, metodo_bindeado)
    end
  end
end
