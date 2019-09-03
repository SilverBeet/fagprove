<template>
  <div id="app">
    <h1 class="title">Øve på gangetabellen</h1>
    <div class="formContainer">
      <form class="form" @submit.prevent="start" v-show="!isPlaying">
        <input type="text" placeholder="Navn" v-model="player.name" class="nameInput">
        <div>
          <ul class="numberList">
            <li class="numberItem" v-for="number in numbers" :key="number">
              {{ number }}
              <span>
                <input
                  type="checkbox"
                  :id="number"
                  v-model="player.selectedNumbers"
                  :value="number"
                >
              </span>
            </li>
          </ul>
        </div>
        <input type="submit" class="submit" value="START">
      </form>
      <div class="gameContainer" v-show="isPlaying">
        <div class="equation">
           {{ player.currentNumber }} X {{ randomNumber }}
        </div>
        <form @submit.prevent="checkOnSubmit">
          <input class="answer" type="number" v-model="player.guess" @input.prevent="checkOnInput">
        </form>
      </div>
    </div>
    <modal v-show="showModal" :player="previousPlayer"  @close="showModal = false"/>
  </div>
</template>

<script>

import modal from './components/scoreModal.vue';

export default {
  name: 'app',
  components: {
    modal,
  },
  data() {
    return {
      player: {
        name: '',
        correctCount: 0,
        failCount: 0,
        guess: null,
        selectedNumbers: [],
        currentNumber: null,
      },
      previousPlayer: {
        name: '',
        correctCount: 0,
        failCount: 0,
        guess: null,
        selectedNumbers: [],
        currentNumber: null,
      },
      correctAnswer: null,
      equationCount: 0,
      randomNumber: null,
      isPlaying: false,
      showModal: false,
      numbers: [...Array(11).keys()].slice(1),
    };
  },

  methods: {
    start() {
      if (this.player.name === '') return;
      if (this.player.selectedNumbers.length === 0) return;
      this.isPlaying = true;
      this.player.currentNumber = this.player.selectedNumbers[Math.floor(Math.random() * this.player.selectedNumbers.length)];
      this.randomNumber = (Math.floor(Math.random() * 10) + 1);
      this.correctAnswer = (this.player.currentNumber * this.randomNumber);
    },
    checkOnInput() {
      if (Number(this.player.guess) === this.correctAnswer) {
        this.player.correctCount += 1;
        this.generateEquation();
      }
    },
    checkOnSubmit() {
      if (Number(this.player.guess) === this.correctAnswer) {
        this.player.correctCount += 1;
        this.generateEquation();
      } else {
        this.player.failCount += 1;
        this.generateEquation();
      }
    },
    generateEquation() {
      this.resetInput();
      this.equationCount += 1;
      if (this.equationCount === 10) this.endGame();
      this.player.currentNumber = this.player.selectedNumbers[Math.floor(Math.random() * this.player.selectedNumbers.length)];
      this.randomNumber = (Math.floor(Math.random() * 10) + 1);
      this.correctAnswer = (this.player.currentNumber * this.randomNumber);
    },
    resetInput() {
      this.player.guess = null;
    },
    resetGame() {
      this.previousPlayer = this.player;
      this.player = {
        name: '',
        correctCount: 0,
        failCount: 0,
        guess: null,
        selectedNumbers: [],
        currentNumber: null,
      };

      this.equationCount = 0;
    },
    endGame() {
      this.isPlaying = false;
      this.showModal = true;
      this.resetGame();
    },
  },

};
</script>

<style>
body {
  margin: 0;
  padding: 0;
  height: 100vh;
  width: 100vw;
  font-family: 'Gill Sans', 'Gill Sans MT', Calibri, 'Trebuchet MS', sans-serif;

}
#app {
  display: flex;
  flex-direction: column;
  height: 100%;
  width: 100%;
  justify-content: center;
  background-color: #acb6b0;
}

.title {
  margin: 0;
  color: white;
  padding-bottom: 35px;
  text-align: center;
}

.formContainer {
  display: grid;
  height: 500px;
  width: 80%;
  border-radius: 10px;
  box-shadow: 0px 10px 25px -5px rgb(0, 0, 0);
  align-self: center;
}

.form {
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.nameInput {
  display: block;
  width: 30%;
  font-size: 20px;
  border: none;
  border-bottom: 1px solid black;
  color: white;
  background-color: #acb6b0;
  margin: 0 auto 50px auto;
  outline: none;
}

.nameInput::placeholder {
  color: #dddddd;
}

.numberList {
  text-align: center;
  margin: 0;
  margin-bottom: 50px;
  padding: 0;
  list-style-type: none;
}

.numberItem {
  margin: 0 5px;

  display: inline-block;
}

.numberItem span {
  vertical-align: middle;
}

.submit {
  display: block;
  margin: 0 auto;
  cursor: pointer;
  border: 1px solid;
  border-radius: 10px;
  color: white;
  padding: 10px;
  background-color: transparent;
  width: 150px;
  outline: none;
  transition: 0.4s ease-in-out;
}

.submit:hover {
  box-shadow: 0px 10px 10px -7px rgb(0, 0, 0);
}


.equation {
  display: block;
  background-color: rgb(64, 68, 60);
  border-radius: 10px;

  width: 300px;
  padding: 50px 0;
  text-align: center;
  color: white;
  margin: 50px auto;
  font-size: 70px;
}

.answer {
  display: block;
  width: 100px;
  font-size: 20px;
  border: none;
  border-bottom: 1px solid black;
  color: white;
  background-color: #acb6b0;
  margin: 50px auto;
  outline: none;
  text-align: center;
}

input[type=number]::-webkit-inner-spin-button,
input[type=number]::-webkit-outer-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

</style>
