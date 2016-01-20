Aplicación desarrollada en Ruby on Rails para [Cafira](http://www.cafira.com/)
## Información general

###Descripción
Cafira es una aplicación web desarrollada en Ruby on Rails, para la "Cámara Argentina de Fabricantes e Importadores de Regalos y Afines" para el manejo de exposiciones y sus respectivos expositores. 


###Tecnologías
* **Versión de ruby:** 2.2.2

* **Versión de rails:** 4.2.4

* **Dependencias:** Visitar [Gemfile](https://github.com/cran-io/cafira/blob/master/Gemfile)

* **Desarrollo principal con:** [ActiveAdmin](https://github.com/activeadmin/activeadmin)


##Diseño de la aplicación


###Diagrama Entidad-Relación
![erm](http://i.imgur.com/HMO6Fxd.png)

###Schema

```
aditional_services
    boolean  "energia"
    integer  "energia_cantidad"
    boolean  "estacionamiento"
    integer  "estacionamiento_cantidad"
    boolean  "nylon"
    boolean  "cuotas_sociales"
    integer  "catalogo_extra_cantidad"
    boolean  "catalogo_extra"
    integer  "coutas_sociales_cantidad"
    integer  "expositor_id"
    datetime "created_at"
    datetime "updated_at"
    boolean  "completed"

blueprint_files
    integer  "state"
    string   "attachment_file_name"
    string   "attachment_content_type"
    integer  "attachment_file_size"
    datetime "attachment_updated_at"
    integer  "infrastructure_id"
    datetime "created_at"
    datetime "updated_at"
    text     "comment"

catalog_images
    datetime "created_at"
    datetime "updated_at"
    string   "attachment_file_name"
    string   "attachment_content_type"
    integer  "attachment_file_size"
    datetime "attachment_updated_at"
    string   "priority"
    integer  "catalog_id"

catalogs
    string   "stand_number"
    string   "twitter"
    string   "facebook"
    string   "type"
    integer  "expositor_id"
    datetime "created_at"
    datetime "updated_at"
    boolean  "completed"
    text     "description"
    string   "phone_number"
    string   "aditional_phone_number"
    string   "email"
    string   "aditional_email"
    string   "website"
    string   "address"
    string   "city"
    string   "province"
    string   "zip_code"

credentials
    string   "name"
    boolean  "armador"
    boolean  "personal_stand
    boolean  "foto_video"
    integer  "expositor_id"
    datetime "created_at"
    datetime "updated_at"
    boolean  "art"
    boolean  "es_expositor"
    date     "fecha_alta"

exposition_expositors
    integer  "exposition_id"
    integer  "expositor_id"
    datetime "created_at"
    datetime "updated_at"

exposition_files
    string   "file_type"
    string   "attachment_file_name"
    string   "attachment_content_type"
    integer  "attachment_file_size"
    datetime "attachment_updated_at"
    integer  "exposition_id"
    datetime "created_at"
    datetime "updated_at"

expositions
    string   "name"
    boolean  "active"
    date     "initialized_at"
    dates_at"
    datetime "created_at"
    datetime "updated_at"
    date     "deadline_catalogs"
    date     "deadline_credentials"
    date     "deadline_aditional_services"
    date     "deadline_infrastructures"

infrastructures
    boolean  "tarima"
    boolean  "paneles"
    datetime "created_at"
    datetime "updated_at"
    integer  "expositor_id"
    boolean  "completed"
    string   "alfombra_tipo"
    boolean  "alfombra"

massive_mails
    string   "subject"
    text     "body"
    string   "attachment_file_name"
    string   "attachment_content_type"
    integer  "attachment_file_size"
    datetime "attachment_updated_at"
    datetime "created_at"
    datetime "updated_at"
    string   "campaign"
    boolean  "sent"

users
    string   "type"
    string   "name"
    string   "cuit"
    datetime "created_at"
    datetime "updated_at"
    string   "email" 
    string   "encrypted_password" 
    string   "reset_password_token"
    datetime "reset_password_sent_at"
    datetime "remember_created_at"
    integer  "sign_in_count" 0,
    datetime "current_sign_in_at"
    datetime "last_sign_in_at"
    inet     "current_sign_in_ip"
    inet     "last_sign_in_ip"

```


###Diagrama de clases
![clases](http://i.imgur.com/3theC6u.png)


##Deploy

###Uso:
Clonar el repositorio, y luego correr:
```{r, engine='bash', count_lines}
$ bundle install
$ rake db:create && rake db:migrate
```

###Setup con docker
Para usar [Docker](http://www.docker.com) (se requiere [docker-compose](https://docs.docker.com/compose/))
```sh
git clone https://github.com/cran-io/cafira.git
cd cafira
cp config/database.docker.yml config/database.yml
docker-compose up
```
Esperamos hasta que ```docker-compose up``` muestre esta salida:
```sh
web_1 | [2015-07-06 17:39:19] INFO  going to shutdown ...
web_1 | [2015-07-06 17:39:19] INFO  WEBrick::HTTPServer#start done.
web_1 | => Booting WEBrick
web_1 | => Rails 4.2.1 application starting in development on http://0.0.0.0:3000
web_1 | => Run `rails server -h` for more startup options
web_1 | => Ctrl-C to shutdown server
```

En una terminal nueva, "loguearse" al container de docker y cargar el esquema de la base de datos.
```sh
docker exec -i -t cafira_web_1 /bin/bash
rake db:schema:load RAILS_ENV=development
rake db:create RAILS_ENV=test
rake db:schema:load RAILS_ENV=test
rake db:seed RAILS_ENV=development
exit
```
Usamos ```docker-compose up``` solo la primera vez. Después, usamos ```docker-compose start``` o ```docker-compose stop```.
```sh
docker-compose <start|stop>
```

###Breve descripción de uso

__Administradores__

Un administrador puede:

+ Ver todos los usuarios de la aplicación: otros administradores, expositores, arquitectos, etc, y crear nuevos. Notar que esta es la manera de crear expositores, en la sección de Usuarios en el menú, especificando el tipo.

+ Ver todas las exposiciones existentes (sección Exposiciones) y editarlas (link "Editar") y así cambiarles los deadlines, nombres, y estado (activo/no activo), etc.

+ Operar sobre una exposición (link "Ver"). Se pueden agregar y quitar expositores previamente creados en la sección de usuarios de manera masiva.

+ Operar sobre los expositores de una exposición (link "Ver" o "Editar"). Se tiene acceso y autorización para ver y editar todos los formularios del expositor:
    + Datos generales
    + Catálogo e imágenes del este
    + Credenciales
    + Servicios Adicionales
    + Infraestructura y planos 

+ Ver el dashboard que muestra exposiciones futuras y su respectivo status.

__Expositores__

Un expositor tiene acceso solamente a sus formularios. Estos persisten entre exposiciones con la posibilidad de editarlos según sea necesario.
Cada formulario aparte de los campos de texto, numéricos y upload de imágenes y planos, tienen un status de "completo" o "incompleto" el cual sigue un criterio trivial de estar completo si todos sus campos están completos, o incompleto si falta alguno. En caso de que uno de los formularios esté "incompleto" ese expositor recibirá un e-mail 7 días antes de su deadline (que se establece cuando se crea la exposición) avisando que tiene que completar el formulario correspondiente, y ese email se repetirá cada 48 horas, acumulando los avisos de los demás formularios incompletos según sus deadlines.
A tener en cuenta: 
+ Las imágenes (1 primaria y 3 secundarias) del catálogo deben ser jpg, jpeg o png y de alta calidad, sino se rechaza el upload (con un aviso en pantalla) y el formulario de catálogo se contempla como “incompleto”.
+ En caso de activar el checkbox de de "catálogo adicional" en la sección de servicios adicionales, se agregaran 4 imagenes adicionales al catálogo.
+ Los planos de infraestructura deben ser jpg, jpeg, png o pdf. Cada uno tiene un status, que puede ser: 
    + _En revisión_: cuando un usuario del tipo arquitecto aún no lo aprobó/desaprobó.
    + _Aprobado_: plano ya aprobado por el arquitecto.
    + _Desaprobado_: plano desaprobado por el arquitecto.
    + _Pre-aprobado_: plano pre aprobado por el arquitecto.
En caso que un plano sea desaprobado, el formulario de infraestructura se contempla como “incompleto”, debiendo volver a completarlo subiendo un plano nuevo.

+ Para que la sección de credenciales se contemple como “completa”, se debe haber creado al menos una credencial.


__Arquitectos__

Tienen acceso a una lista de expositores (nombre, email) con sus respectivos planos. Pueden descargarlos, y aprobarlos/desaprobarlos (sección Planos). 
Tienen acceso a una lista de infraestructuras para descargar

#Emails
##Emails transaccionales:
###Descripción
Hay dos servicios principales de emails transaccionales:
+  Emails que se envían cuando se crea un expositor.
+  Emails que se envían una vez por día a los expositores que no esten cumpliendo con el plan de tiempos brindado por CAFIRA.
+  Emails que se envían cuando un arquitecto pre aprueba o desaprueba un plano subido por el expositor. 
###Configuración 
#### Crontab:
```
0 0 * * * cd /home/deploy/cafira/current && /home/deploy/.rbenv/shims/rake RAILS_ENV=production deadline_alerts:send_alert_emails
```
##Emails masivos:
###Descripción
Los mails masivos se crean y envían desde la sección Mails de la aplicación. Se permite crear el email, especificando el asunto, el cuerpo (permitiendo formato HTML) y un archivo adjunto. Una vez creado, el contenido del email se puede actualizar siempre y cuando no se haya enviado. Una vez enviado, este no se puede volver a enviar, y se cataloga como un email "enviado". 



**Developed by [cran.io](http://cran.io)**