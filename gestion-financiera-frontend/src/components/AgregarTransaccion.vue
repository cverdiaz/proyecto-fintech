<template>
    <div class="container mt-4">
      <div class="text-end">
        <button type="button" class="btn btn-sm btn-outline-danger d-flex align-items-center gap-1" @click="$emit('cerrar')">
          <span aria-hidden="true">&times;</span> Cerrar
        </button>
      </div>
      <h2 class="mb-3">{{ esEdicion ? 'Editar Transacción' : 'Agregar Transacción' }}</h2>
      <form @submit.prevent="guardarTransaccion">
        <div class="mb-3">
          <label for="tipo" class="form-label">Tipo</label>
          <select v-model="transaccion.tipo" class="form-select" id="tipo" required>
            <option value="">Seleccione</option>
            <option value="ingreso">Ingreso</option>
            <option value="gasto">Gasto</option>
          </select>
          <div class="invalid-feedback">{{ errores.tipo }}</div>
        </div>
  
        <div class="mb-3">
          <label for="monto" class="form-label">Monto</label>
          <input v-model.number="transaccion.monto" type="number" class="form-control" id="monto" required />
          <div class="invalid-feedback">{{ errores.monto }}</div>
        </div>
  
        <div class="mb-3">
          <label for="descripcion" class="form-label">Descripción</label>
          <input v-model="transaccion.descripcion" type="text" class="form-control" id="descripcion" />
        </div>
  
        <div class="mb-3">
          <label for="fecha" class="form-label">Fecha</label>
          <input v-model="transaccion.fecha" type="date" class="form-control" id="fecha" required />
          <div class="invalid-feedback">{{ errores.fecha }}</div>
        </div>
  
        <button type="submit" class="btn btn-primary">Guardar</button>
      </form>
    </div>
  </template>
  
  <script setup>
 import { ref, watch } from 'vue'
  import api from '@/services/api'
  import { useToast } from 'vue-toastification'
  
  const emit = defineEmits(['transaccion-agregada'])
  const props = defineProps({
  transaccionEditar: {
    type: Object,
    default: null
  }
})

  const toast = useToast()

  const errores = ref({
    tipo: '',
    monto: '',
    fecha: ''
    })
  
  const transaccion = ref({
    tipo: '',
    monto: null,
    descripcion: '',
    fecha: ''
  })

  const esEdicion = ref(false)

  // Si llega una transacción para editarla, llenamos el formulario
watch(() => props.transaccionEditar, (nueva) => {
  if (nueva) {
    transaccion.value = { ...nueva }
    esEdicion.value = true
  }
}, { immediate: true })
  
const guardarTransaccion = async () => {

// Limpiar errores
  errores.value = {
    tipo: '',
    monto: '',
    fecha: ''
  }

  // Validar campos
  let valido = true

  if (!transaccion.value.tipo) {
    errores.value.tipo = 'El tipo es obligatorio.'
    valido = false
  }

  if (!transaccion.value.monto || transaccion.value.monto <= 0) {
    errores.value.monto = 'El monto debe ser mayor que 0.'
    valido = false
  }

  if (!transaccion.value.fecha) {
    errores.value.fecha = 'La fecha es obligatoria.'
    valido = false
  }

  if (!valido) return

    console.log('Enviando transacción:', transaccion.value) // <- esto debería verse
    try {

        let response

        if (esEdicion.value) {
          // EDITAR
          response = await api.put(`/transacciones/${transaccion.value.id}`, transaccion.value)
          toast.success('Transacción actualizada correctamente')
        } else {
          // NUEVA
          response = await api.post('/transacciones', transaccion.value)
          toast.success('Transacción guardada correctamente')
        }
        
        toast.success('Transacción guardada correctamente')


        emit('transaccion-agregada', response.data) // ⬅️ Emitimos el evento con los datos nuevos
        // Limpiar el formulario
        transaccion.value = {
          tipo: '',
          monto: null,
          descripcion: '',
          fecha: ''
        }
      
    } catch (error) {
      toast.error('Error al guardar la transacción')
      console.error(error)
    }
  }
  </script>
  
  <style scoped>
  .container {
    max-width: 500px;
  }
  .formulario {
  max-width: 400px;
  margin: 20px auto;
  padding: 1rem;
  border: 1px solid #ccc;
  border-radius: 8px;
}
label {
  display: block;
  margin-top: 1rem;
}
input,
select {
  width: 100%;
  padding: 0.5rem;
}
button {
  margin-top: 1rem;
  padding: 0.5rem 1rem;
}
  </style>
  