require 'httparty'
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
URL='https://sepa.utem.cl/rest/api/v1'
AUTH = {username: '2E5Vw7WUCm', password: '0754e0cbf6df85c40be0715e643c9f1c'}


#LISTADO DE ASIGNATURAS CON CODIGO 'INF'

#URL
ASIGNATURAS = '/docencia/asignaturas'
#Instancia para obtener Json
respuesta1 = HTTParty.get(URL+ASIGNATURAS, basic_auth: AUTH)
#Arreglos para guaradar el nombre y código de la asignatura
nombres = []
codigos = []
#Recorrido del Json de asignaturas
respuesta1.each do |asignatura|
	aux = asignatura['codigo']				#Obtencion del codigo de la asignatura
	if aux[0] == 'I' && aux[1] == 'N' && aux[2] == 'F'	#Comparacion para determinar si es 'INF'
		nombres << asignatura['nombre']			#Almacenamiento del nombre
		codigos << asignatura['codigo']			#Almacenamiento del codigo
		print "Asignatura:   ",asignatura['nombre']
		print "\n"
		print "Codigo:       ",asignatura['codigo']
		print "\n\n"
	end
end

#OBTENCION DE LA CANTIDAD Y LAS ASIGNATURAS QUE SE IMPARTIERON EL AÑO 2015 CON CODIGO 'INF'
#variables para almacenar las asignaturas de ese año y la cantidad 
asignaturas_2015 = []
cantidad = 0
#Recorrido del arreglo de de codigos 'INF' obtendio antes
for i in(0..codigos.length-1)	
	AUX = '/docencia/asignaturas/'+codigos[i]+'/cursos'	#creacion de la URL
	respuesta2 = HTTParty.get(URL+AUX, basic_auth: AUTH)	#Obtencion del Json
	if(respuesta2[0] != nil)				#Verificacion de que no sea nulo o nil
		if(respuesta2[0]['anio'].to_i == 2015)		#Caso en que el año es 2015
			print "\n\n"
			asignaturas_2015 << respuesta2[0]['asignatura']['nombre']
			print "Asignatura:   ",respuesta2[0]['asignatura']['nombre']
			print "\n"
			print "Codigo:       ",respuesta2[0]['codigo']
			print "\n"
			print "Año:          ",respuesta2[0]['anio']
			print "\n\n"	
			cantidad = cantidad +1
		end
	end
end

print "\n\n"
print "La cantidad de asignaturas impartidas en el año 2015 fueron: ",cantidad
print "\n\n"

#OBTENCION DE LOS DOCENTES NACIDOS ANTES DEL 1980

#creacion de la URL
DOCENTES = '/academia/docentes'
#obtencion del Json
respuesta3 = HTTParty.get(URL+DOCENTES, basic_auth: AUTH)

#variables para almacenar el nombre y fecha de nacimiento de los profesores
profesores = []
fecha_nac = []
fecha = ""
anio = 0
respuesta3.each do |docente|
	fecha = docente['fechaNacimiento']								#Obtencion de la fecha de nacimiento
	for i in (0..3)											#Conversion string->int
		anio = (anio * 10) + fecha[i].to_i
	end
	if (anio < 1980)										#Comparacion de años
		profesores << docente['nombres']
		fecha_nac << docente['fechaNacimiento']
		print "Nombre:                 ",docente['nombres']," ",docente['apellidos']
		print "\n"
		print "Fecha de nacimiento:    ",docente['fechaNacimiento']
		print "\n\n"
	end
anio = 0												#Seteo del acumulador en cero
end

