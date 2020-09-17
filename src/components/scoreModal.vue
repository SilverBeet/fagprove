<template>
  <transition name="modal">
    <div class="modalMask">
      <div class="modalContainer">
        <button class="modalBtn" @click="$emit('close')">X</button>
        <div v-if="isAllCorrect">
          <img
            class="star"
            src="https://purepng.com/public/uploads/large/purepng.com-gold-starstargeometricallydecagonconcavestardomyellow-stargold-1421526501484pjepy.png"
            alt="star"
          />
        </div>
        <div v-else>
          <img
            class="star"
            src="https://purepng.com/public/uploads/large/purepng.com-silver-starstargeometricallydecagonconcavestardomclipartsilver-1421526502895pbjlx.png"
            alt="star"
          />
        </div>
        <div class="playerInfo">
          <h3 class="playerName">Name: {{ player.name }}</h3>
          <h4>{{ player.correctCount }} - Correct</h4>
          <h4>{{ player.wrongCount }} - Wrong</h4>
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
export default {
  props: ['player'],
  computed: {
    isAllCorrect() {
      return this.player.correctCount === 15;
    },
  },
};
</script>

<style>
.modalMask {
  position: fixed;
  z-index: 9998;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: #00000080;
  transition: opacity 0.3s ease;
}

.modalContainer {
  display: flex;
  margin: 300px auto 0 auto;
  border-radius: 10px;
  width: 500px;
  height: 200px;
  background-color: #b8beb5;
}

.playerInfo {
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 20px;
}

.star {
  display: flex;
  flex-direction: column;
  justify-content: center;
  width: 175px;
  padding: 20px;
}

.modalBtn {
  float: right;
  cursor: pointer;
  border: none;
  border-radius: 10px;
  outline: none;
}
</style>
