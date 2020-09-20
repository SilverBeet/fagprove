<template>
  <div id="app">
    <h1 class="title">Practice multiplication</h1>
    <div class="formContainer">
      <form class="form" @submit.prevent="start" v-show="!isPlaying">
        <div class="errorMsg">{{ errorMsg }}</div>
        <input type="text" placeholder="Name" v-model="player.name" class="nameInput" />
        <div class="numberContainer">
          <span class="chooseNumberLabel">Choose one or more:</span>
          <ul class="numberList">
            <li class="numberItem" v-for="number in numbers" :key="number">
              {{ number }}
              <span>
                <input
                  type="checkbox"
                  :id="number"
                  v-model="player.selectedNumbers"
                  :value="number"
                />
              </span>
            </li>
          </ul>
        </div>
        <input type="submit" class="submit" value="START" />
      </form>
      <div class="gameWrapper" v-show="isPlaying">
        <div class="equation">
          <div class="eqCount">{{ equationCount }} / 15</div>
          {{ player.currentNumber }}
          <span class="times">x</span>
          {{ randomNumber }}
        </div>
        <div v-show="isCorrect !== null">
          <div class="msg correct" v-show="isCorrect">Correct</div>
          <div class="msg wrong" v-show="!isCorrect">Wrong</div>
        </div>
        <div class="answerWrapper">
          <input
            class="answer"
            :class="borderChangeOnAnswer"
            type="text"
            ref="answerInput"
            v-model="player.guess"
            @input.prevent="checkOnInput"
            :disabled="inputDisabled"
            :maxlength="correctAnswer.toString().length"
          />
        </div>
      </div>
    </div>
    <modal v-show="showModal" :player="previousPlayer" @close="showModal = false" />
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
      player: this.playerObject(),
      previousPlayer: {
        name: '',
        correctCount: 0,
        wrongCount: 0,
      },
      isCorrect: null,
      correctAnswer: '',
      equationCount: 0,
      isPlaying: false,
      showModal: false,
      nextNum: null,
      randomNumber: null,
      errorMsg: '',
      inputDisabled: false,
      numbers: [...Array(11).keys()].slice(1),
    };
  },

  methods: {
    start() {
      if (!this.required()) return;
      this.generateEquation();
      this.focusAnswer();
      this.isPlaying = true;
    },
    required() {
      if (this.player.name.trim().length <= 0) {
        return this.setErrorMsg('Please fill in a name.');
      }
      if (this.player.selectedNumbers.length <= 0) {
        return this.setErrorMsg('Please choose one or more numbers.');
      }
      return this.setErrorMsg('', true);
    },
    getNext(isCorrect, countType) {
      this.inputDisabled = true;
      this.isCorrect = isCorrect;
      this.player[countType] += 1;
      setTimeout(() => {
        this.inputDisabled = false;
        this.generateEquation();
      }, 1000);
    },
    checkOnInput() {
      if (!/^\d+$/.test(this.player.guess)) this.resetInput();
      const isAMatch = Number(this.player.guess) === Number(this.correctAnswer);
      if (this.player.guess.length === this.correctAnswer.toString().length) {
        if (isAMatch) {
          this.getNext(isAMatch, 'correctCount');
        } else {
          this.getNext(isAMatch, 'wrongCount');
        }
      }
    },
    generateEquation() {
      const randomSelectedIdx = Math.floor(Math.random() * this.player.selectedNumbers.length);
      this.resetInput();
      this.focusAnswer();
      this.isCorrect = null;
      if (this.equationCount === 15) this.endGame();
      else this.equationCount += 1;
      this.player.currentNumber = this.player.selectedNumbers[randomSelectedIdx];
      this.correctAnswer = this.player.currentNumber * this.randomize();
    },
    endGame() {
      this.previousPlayer = this.player;
      this.player = this.playerObject();
      this.equationCount = 0;
      this.isPlaying = false;
      this.showModal = true;
    },
    playerObject: () => ({
      name: '',
      correctCount: 0,
      wrongCount: 0,
      guess: '',
      selectedNumbers: [],
      currentNumber: null,
    }),
    setErrorMsg(msg, bool = false) {
      this.errorMsg = msg;
      return bool;
    },
    resetInput() {
      this.player.guess = '';
    },
    focusAnswer() {
      this.$nextTick(() => this.$refs.answerInput.focus());
    },
    randomize() {
      this.randomNumber = Math.floor(Math.random() * 10) + 1;
      return this.randomNumber;
    },
  },
  computed: {
    borderChangeOnAnswer() {
      if (this.isCorrect === null) return '';
      return this.isCorrect ? 'answer-correct' : 'answer-wrong';
    },
  },
};
</script>

<style>
body {
  margin: 0;
  padding: 0;
  height: 100vh;
  font-family: monospace, sans-serif;
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
  color: #ffffff;
  padding-bottom: 35px;
  text-align: center;
}

.formContainer {
  position: relative;
  height: 315px;
  width: 70%;
  border-radius: 10px;
  box-shadow: 0px 10px 25px -5px #000000;
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
  border-bottom: 1px solid #000000;
  color: white;
  background-color: #acb6b0;
  margin: 0 auto 50px auto;
  outline: none;
}

.nameInput::placeholder {
  color: #dddddd;
}

.numberContainer {
  display: flex;
  align-items: center;
  margin: 0 auto;
}

.gameWrapper {
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.chooseNumberLabel {
  margin: 0 10px;
}

.numberList {
  margin: 0;
  padding: 0;
  list-style-type: none;
}

.numberItem {
  margin: 0 5px;
  display: inline-block;
  vertical-align: middle;
}

.numberItem span {
  vertical-align: middle;
}

.submit {
  display: block;
  margin: 20px auto;
  cursor: pointer;
  border: 1px solid;
  border-radius: 10px;
  color: #ffffff;
  padding: 10px;
  background-color: transparent;
  width: 150px;
  outline: none;
  transition: 0.2s ease-in;
}

.submit:hover {
  color: #40443c;
}

.equation {
  font-family: monospace;
  display: block;
  background-color: #40443c;
  border-radius: 10px;
  position: relative;
  width: 300px;
  padding: 20px;
  text-align: center;
  color: #dbdbdb;
  margin: 40px auto;
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
  border-bottom: 1px solid #000000;
  color: #ffffff;
  background-color: #acb6b0;
  outline: none;
  text-align: center;
  transition: border-color .1s ease-in;
}

.answer:focus {
  border-color: #004680;
}

.answer-correct {
  border-color: green;
}

.answer-wrong {
  border-color: red;
}

.msg {
  font-size: 20px;
  position: absolute;
  top: 205px;
  left: 50%;
  transform: translate(-50%, 50%);
  margin-bottom: 20px;
}

.points {
  width: 340px;
}

.wrong {
  color: #ff0000b2;
}

.correct {
  color: #008000;
}

.errorMsg {
  display: block;
  color: #ff0000b2;
  margin: 25px auto;
}

.eqCount {
  position: absolute;
  top: 0;
  right: 0;
  padding: 10px;
  font-size: 15px;
  color: #5f5f5f
}

@media screen and (max-width: 750px) {
  .chooseNumberLabel {
    font-size: 12px;
  }
  .numberItem {
    font-size: 14px;
  }
  .nameInput {
    display: block;
    width: calc(100% - 10%);
    margin: 10px auto;
    padding: 0;
    font-size: 14px;
  }
  .formContainer {
    height: 250px;
  }
  .equation {
    width: 200px;
    font-size: 50px;
    margin: 10px auto;
  }
  .msg {
    top: 145px;
    font-size: 18px;
  }
  .answerWrapper {
    margin-top: 20px;
  }
}
@media screen and (max-width: 480px) {
  .formContainer {
    height: 270px;
  }
  .equation {
    width: 130px;
    font-size: 30px;
    margin: 10px auto;
  }
  .eqCount {
    padding: 5px;
    font-size: 12px;
  }
}
</style>
