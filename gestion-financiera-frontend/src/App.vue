<template>
  <div class="container text-center mt-5">
    <h1>Gestión Financiera</h1>
    <button @click="mostrarModal = true" class="btn btn-primary mt-3">Agregar Transacción</button>

    <hr class="mt-4 my-4" />
    <br>

    <Transacciones 
      :transacciones="transacciones"  
      @editar-transaccion="editarTransaccion" 
    />

    <!-- Modal -->
    <div v-if="mostrarModal" class="modal-backdrop">
      <div class="modal-container">
        <AgregarTransaccion 
          :transaccionEditar="transaccionSeleccionada"
          @transaccion-agregada="transaccionAgregada"
          @cerrar="cerrarModal"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import api from './services/api'
import Transacciones from './components/Transacciones.vue'
import AgregarTransaccion from './components/AgregarTransaccion.vue'

const transacciones = ref([])
const transaccionSeleccionada = ref(null)
const mostrarModal = ref(false)

const obtenerTransacciones = async () => {
  try {
    const response = await api.get('/transacciones')
    transacciones.value = response.data
    transaccionSeleccionada.value = null
  } catch (error) {
    console.error('Error al obtener transacciones:', error)
  }
}

const editarTransaccion = (transaccion) => {
  transaccionSeleccionada.value = transaccion
  mostrarModal.value = true
}

const cerrarModal = () => {
  mostrarModal.value = false
  transaccionSeleccionada.value = null
}

const transaccionAgregada = (nueva) => {
  obtenerTransacciones()
  cerrarModal()
}

onMounted(() => {
  obtenerTransacciones()
})
</script>

<style scoped>

.modal-backdrop {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1050;
}
.modal-container {
  background-color: white;
  padding: 2rem;
  border-radius: 10px;
  width: 90%;
  max-width: 500px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.25);
}
</style>
