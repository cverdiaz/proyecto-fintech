<template>
  <div>
    <h3 class="text-center">Lista de Transacciones</h3>

    <div v-if="transacciones.length === 0" class="alert alert-info text-center">
      No hay transacciones registradas.
    </div>

    <ul class="list-group">
      <li
        v-for="transaccion in transacciones"
        :key="transaccion.id"
        class="list-group-item d-flex justify-content-between align-items-center"
      >
        <div>
          <strong>{{ transaccion.tipo.toUpperCase() }}</strong> - ${{ transaccion.monto }} -
          {{ transaccion.descripcion }} - {{ formatearFecha(transaccion.fecha) }}
        </div>
        <div>
          <button @click="editarTransaccion(transaccion)" class="btn btn-sm btn-warning me-2">
            Editar
          </button>
          <button @click="eliminarTransaccion(transaccion.id)" class="btn btn-sm btn-danger">
            Eliminar
          </button>
        </div>
      </li>
    </ul>
  </div>
</template>

<script setup>
import api from '@/services/api'
import { defineProps, defineEmits } from 'vue'
import { useToast } from 'vue-toastification'

const toast = useToast()
const emit = defineEmits(['editar-transaccion', 'transaccion-eliminada'])

const props = defineProps({
  transacciones: {
    type: Array,
    required: true
  }
})

const eliminarTransaccion = async (id) => {
  if (!confirm('¿Estás seguro de que deseas eliminar esta transacción?')) return

  try {
    await api.delete(`/transacciones/${id}`)
    toast.success('Transacción eliminada')
    emit('transaccion-eliminada')
  } catch (error) {
    toast.error('Error al eliminar transacción')
    console.error(error)
  }
}

const editarTransaccion = (transaccion) => {
  emit('editar-transaccion', transaccion)
}
const formatearFecha = (fecha) => {
  return new Date(fecha).toLocaleDateString('es-CL', {
    day: '2-digit',
    month: 'short',
    year: 'numeric'
  })
}
</script>
