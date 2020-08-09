<template>
  <div id="app">
    <h1 class="title">Øve på gangetabellen</h1>
    <div class="formContainer">
      <form class="form" @submit.prevent="start" v-show="!isPlaying">
        <div class="errorMsg">{{ errorMsg }}</div>
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
          <div class="msg correct" v-show="isCorrect">Riktig</div>
          <div class="msg wrong" v-show="isCorrect === false">Feil</div>
          <div class="eqCount">{{ equationCount }} av 15</div> 
           {{ player.currentNumber }} <span class="times">x</span> {{ randomNumber }}
        </div>
        <div class="answerWrapper">
          Svar: <input class="answer" type="number" v-model="player.guess" @input.prevent="checkOnInput">
        </div>
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
        wrongCount: 0,
        guess: null,
        selectedNumbers: [],
        currentNumber: null,
      },
      previousPlayer: {
        name: '',
        correctCount: 0,
        wrongCount: 0,
      },
      isCorrect: null,
      correctAnswer: null,
      equationCount: 0,
      randomNumber: null,
      isPlaying: false,
      showModal: false,
      nextNum: null,
      errorMsg: '',
      numbers: [...Array(11).keys()].slice(1),
    };
  },

  methods: {
    start() {
      if (this.required()) return
      this.isPlaying = true;
      this.equationCount += 1;
      const randomSelected = Math.floor(Math.random() * this.player.selectedNumbers.length);
      this.player.currentNumber = this.player.selectedNumbers[randomSelected];
      this.randomNumber = this.randomize();
      this.correctAnswer = (this.player.currentNumber * this.randomNumber);
    },
    required() {
      if (this.player.name === '') {
        this.errorMsg = 'Vennligst fyll inn et navn.';
        setTimeout(() => {
          this.errorMsg = '';
        }, 2000);
        return true
      }
      if (this.player.selectedNumbers.length === 0) {
        this.errorMsg = 'Vennligst velg ett eller flere tall.';
        setTimeout(() => {
          this.errorMsg = '';
        }, 2000);
        return true
      }
    },
    checkOnInput() {
      const userGuessLen = this.player.guess.toString().length;
      const correctAnswerLen = this.correctAnswer.toString().length;
      if (this.player.guess === '') this.player.guess = null;
      if (userGuessLen === correctAnswerLen) {
        if (Number(this.player.guess) === this.correctAnswer) {
          this.player.correctCount += 1;
          this.isCorrect = true;
          setTimeout(() => {
            this.generateEquation();
          }, 500);
        } else {  
          this.isCorrect = false;
          setTimeout(() => {
            this.player.wrongCount += 1;
            this.generateEquation();
          }, 500)
        }
      }
    },
    randomize() {
      if (this.randomNumber !== this.nextNum) {
        this.randomNumber = this.nextNum;
      } else if (this.randomNumber === this.nextNum) {
        this.randomNumber = (this.nextNum === 10 ? this.nextNum - 1 : this.nextNum + 1);
      }

      this.nextNum = Math.floor(Math.random() * 10) + 1;;

      return this.randomNumber;
    },
    generateEquation() {
      this.resetInput();
      if (this.equationCount === 15) this.endGame();
      this.equationCount += 1;
      this.isCorrect = null;
      const randomSelected = Math.floor(Math.random() * this.player.selectedNumbers.length);
      this.player.currentNumber = this.player.selectedNumbers[randomSelected];
      this.randomNumber = this.randomize();
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
        wrongCount: 0,
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
  transition: 0.2s ease-in;
}

.submit:hover {
  color: rgb(64, 68, 60);
}


.equation {
  font-family: monospace;
  display: block;
  background-color: rgb(64, 68, 60);
  border-radius: 10px;
  position: relative;
  width: 300px;
  padding: 50px 0;
  text-align: center;
  color: #dbdbdb;
  margin: 75px auto;
  font-size: 70px;
}


.answerWrapper {
  display: flex;
  justify-content: center;
  align-items: center;
}

.answer {
  display: inline-block;
  width: 100px;
  font-size: 20px;
  border: none;
  border-bottom: 1px solid black;
  color: white;
  background-color: #acb6b0;
  outline: none;
  text-align: center;
}

.msg {
  font-size: 20px;
  position: absolute;
  top: 10px;
  left: 50%;
  transform: translate(-50%, 50%);
  margin-bottom: 20px;
}

.wrong {
  color: rgba(255, 0, 0, 0.698);
}

.correct {
  color: green;
}


input[type=number]::-webkit-inner-spin-button,
input[type=number]::-webkit-outer-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

.errorMsg {
  display: block;
  color: rgba(255, 0, 0, 0.698);
  margin: 25px auto;
}

.eqCount {
  font-size: 15px;
  color: rgb(141, 141, 141);
}

</style>
