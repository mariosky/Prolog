# Scryer Prolog

**Hoja de referencia · Paradigmas de Programación · Juego de los pasillos**

Scryer es una implementación de Prolog que sigue fielmente el estándar ISO. Esto hace que 
cambie un poco la manera de trabajar con respecto a la implementación de SWI-Prolog que hemos utilizado. 
Esta hoja de referencia te ayudará a nevegar las diferencias.

## Abrir, ejecutar y recargar

Desde la terminal, en la carpeta donde guardaste el archivo:

```sh
scryer-prolog pasillos.pl
```

| En la consola de Scryer | Para qué sirve |
| --- | --- |
| `['pasillos.pl'].` | Carga el archivo. Repite la consulta después de guardar cambios. |
| `iniciar.` | Restablece el estado de la partida y muestra el vestíbulo. |
| `mirar.` | Describe la habitación y muestra sus objetos. |
| `ir(norte).` / `tomar(llave).` | Mueve al jugador o recoge un objeto. |
| `inventario.` / `abrir_puerta.` | Muestra lo que llevas o intenta abrir la salida. |
| `halt.` | Sale de Scryer. |

En la consola, `?-` es el indicador que ya muestra Scryer. Escribe la consulta con un punto final. Cuando Scryer ofrece más soluciones, pulsa `;` para pedir otra. Prueba con `conectar(pasillo_central, D, Destino).`

## Modulos usados frecuentemente

SWI Prolog ya tiene algunos módulos precargados, en el caso de Scryer hay que agregarlos para 
aprovechar esta funcionalidad.

En el archivo del programa se escriben las directivas, con `:-` al inicio. En la consola puedes ejecutarlas como consultas, por ejemplo `use_module(library(format)).`

| Directiva en el archivo | Qué habilita |
| --- | --- |
| `:- use_module(library(format)).` | `format/2` para imprimir y `listing/1` para mostrar cláusulas. |
| `:- use_module(library(debug)).` | `$` para trazar un objetivo y `$-` para mostrar sus excepciones. |
| `:- use_module(library(iso_ext), [forall/2]).` | `forall/2`, útil para recorrer el inventario e imprimir cada objeto. |
| `:- use_module(library(lists)).` | Predicados de listas como `member/2` y `append/3`. |
| `:- use_module(library(dcgs)).` | `phrase/2`, `phrase/3` y `seq//1` para analizar comandos con gramáticas. |

## Inspeccionar y trazar

```prolog
?- use_module(library(format)).
?- listing(objeto_en/2).
?- posicion_actual(Habitacion).
?- findall(X, inventario(X), Objetos).
?- use_module(library(debug)).
?- $(conectar(pasillo_central, norte, Destino)).
?- $(ir(norte)).
```

- `objeto_en/2` identifica un predicado por su nombre y aridad. El listado muestra las cláusulas que tiene cargadas. `findall/3` devuelve `[]` si el inventario está vacío.
- `$(Objetivo)` es la forma de traza puntual de `library(debug)`. Si vienes de `trace.` en SWI-Prolog, prueba primero con una consulta al mapa para ver la traza sin mover al jugador. Al ejecutar `$(ir(norte)).` sí intentas hacer el movimiento.
- Para ver valores dentro de una regla, añade temporalmente algo como `format("Origen: ~w, destino: ~w~n", [Aqui, Alli])` después de `conectar(Aqui, Direccion, Alli)`.

## Cambios típicos al pasar de SWISH a Scryer

| Tarea | Sintaxis para el juego |
| --- | --- |
| Declarar estado modificable y público | `:- dynamic(posicion_actual/1).` |
| Imprimir un mensaje fijo | `format("Puerta abierta.~n", []).` |
| Imprimir un valor | `format("Tienes: ~w~n", [Objeto]).` |
| Leer un término desde el juego | `read(Comando)`. El jugador escribe, por ejemplo, `ir(norte).` con punto. |
| Representar texto y datos | `"norte"` es una lista de caracteres por defecto. `norte` y `'norte'` son el átomo que espera `ir/1`. |

Declara antes de sus hechos los cuatro predicados que cambian: `posicion_actual/1`, `inventario/1`, `estado_puerta/1` y `objeto_en/2`. `assertz/1` añade una cláusula, `retract/1` quita una que coincida y `retractall/1` quita todas las que coincidan. Retroceder por *backtracking* no deshace esos cambios. Usa `iniciar.` para repetir una prueba desde el vestíbulo.

### Prueba rápida del juego

```prolog
?- iniciar.
?- ir(norte), ir(este), tomar(llave).
?- inventario.
?- ir(oeste), ir(norte), abrir_puerta.
```

Debes ver la llave en el inventario y el mensaje de victoria al abrir la puerta. Si aparece `syntax_error(incomplete_reduction)` al cargar, revisa la línea que indica el error. Si contiene `:- dynamic predicado/1.`, escribe `:- dynamic(predicado/1).` Si `listing/1` o `format/2` no se encuentran, carga `library(format)`.

**Documentación de Scryer:** [Instalación](https://www.scryer.pl/) · [format y listing](https://www.scryer.pl/format) · [debug](https://www.scryer.pl/debug) · [iso_ext](https://www.scryer.pl/iso_ext) · [listas](https://www.scryer.pl/lists) · [DCG](https://www.scryer.pl/dcgs).
