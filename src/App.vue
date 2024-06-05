<template>
  <div id="desk">
    <h2>{{ question }}</h2>
    <vue-drawing-canvas
      ref="canvas"
      :lineJoin="'round'"
      :lineCap="'round'"
      :width="250"
      :height="250"
      v-model:image="characterImage"
      @touchstart.stop
      @touchmove.prevent
    />
    <div>
      <button @click="clear">Отчистить</button>
      <button @click="rate">Проверить</button>
    </div>
    <button @click="next">Следующее слово</button>
    <h2 v-if="score != 0">{{ score }}</h2>
  </div>
</template>

<script>
import VueDrawingCanvas from "vue-drawing-canvas";

export default {
  name: "App",
  components: {
    VueDrawingCanvas,
  },
};
</script>

<script setup>
import { ref, onMounted } from "vue";
import axios from "axios";
import qs from "qs";

const canvas = ref(null);

const characterImage = defineModel();

const question = ref("")
const rightAnswer = ref("")
const currentIndex = ref(0)

const characters = ref([])

const score = ref(0)

const api = "https://chinesebeeapi-production.up.railway.app"

onMounted(() => {
  console.log("AAAAAAAAA")
  
  const options = {
    method: "GET",
    url: `${api}/saved-words?user_id=1998388306"`,
  };
  axios(options).then((response) => {
    if (response.data["success"] == true) {
      characters.value = response.data["saved_words"]
      question.value = characters.value[currentIndex.value]["russian"]
      rightAnswer.value = characters.value[currentIndex.value]["chinese"] 
      console.log(characters.value)
    } else {
      console.log(response)
    }
  }); 
});

function clear() {
  canvas.value.reset();
}

function rate() {
  score.value = "Обработка..."
  const options = {
    method: "POST",
    header: { "content-type": "application/x-www-form-urlencoded" },
    data: qs.stringify({ image: characterImage.value, target: rightAnswer.value }),
    url: `${api}/accuracy-score`,
  };
  axios(options).then((response) => {
    console.log(response.data)
    if (response.data["success"] == true) {
      if (response.data["score"] == 0) {
        console.log("set score to string")
        score.value = "0%, " + question.value + " - " + rightAnswer.value
      } else {
        score.value = response.data["score"] * 100 + "%"

      }
    }
  });
}

function next() {
  score.value = 0
  currentIndex.value++
  if (currentIndex.value == characters.value.length) {
    currentIndex.value = 0
  }
  question.value = characters.value[currentIndex.value]["russian"]
  rightAnswer.value =characters.value[currentIndex.value]["chinese"]  
}

</script> 

<style>
* {
  font-family:'Trebuchet MS', 'Lucida Sans Unicode', 'Lucida Grande', 'Lucida Sans', Arial, sans-serif;

}
:root {
  width: 100vw;
  height: 100vh;
  background-color: grey;
  display: flex;
  justify-content: center;
  align-items: center;
  font-family:'Trebuchet MS', 'Lucida Sans Unicode', 'Lucida Grande', 'Lucida Sans', Arial, sans-serif;
}
#desk {
  height: 80vh;
  width: 80vw;
  padding: 5vw;
  border-radius: 5px;
  background-color: burlywood;
  display: flex;
  flex-direction: column;
  align-items: center;
}
canvas {
  background-color: white;
  display: inline-block;
  box-shadow: 0 2px 5px grey;
  border-radius: 5px;
  margin: .25rem;
}

button {
  background-color: #fff;
  background-image: none;
  background-position: 0 90%;
  background-repeat: repeat no-repeat;
  background-size: 4px 3px;
  border-radius: 15px 225px 255px 15px 15px 255px 225px 15px;
  border-style: solid;
  border-width: 2px;
  box-shadow: rgba(0, 0, 0, .2) 15px 28px 25px -18px;
  box-sizing: border-box;
  outline: none;
  padding: .35rem;
  margin: .10rem;
  transition: all 235ms ease-in-out;
  touch-action: manipulation;
  border-bottom-left-radius: 15px 255px;
  border-bottom-right-radius: 225px 15px;
  border-top-left-radius: 255px 15px;
  border-top-right-radius: 15px 225px;
  font-weight: bold;
  color: #41403e;

  user-select: none;
  -webkit-user-select: none;
}

button:hover {
  box-shadow: rgba(0, 0, 0, .3) 2px 8px 8px -5px;
  transform: translate3d(0, 0.5px, 0);
}

button:focus {
  box-shadow: rgba(0, 0, 0, .3) 2px 8px 4px -6px;
}

</style>
