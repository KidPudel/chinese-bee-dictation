<template>
  <div id="desk">
    <h1>Chinese Bee Dictation</h1>
    <vue-drawing-canvas ref="canvas" :width="500" />
    <button @click="clear">Отчистить</button>
    
  </div>
</template>

<script>
import VueDrawingCanvas from "vue-drawing-canvas"

export default {
  name: "App",
  components: {
    VueDrawingCanvas,
  }
}
</script>


<script setup>
import {ref, onMounted} from 'vue'

const canvas = ref(null)

onMounted(() => {
  canvas = this.$refs.canvas
})

function clear() {
  canvas.value.reset()
}




</script>

<style>
:root {
  width: 100vw;
  height: 100vh;
  background-color: grey;
  display: flex;
  justify-content: center;
  align-items: center;
}
#desk {
  height: 80vh;
  width: 80vw;
  padding: 5vw;
  border-radius: 5px;
  background-color: burlywood;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}
canvas {
  background-color: white;
  display: inline-block;
  box-shadow: 0 2px 5px grey;
  border-radius: 5px;
}
</style>
