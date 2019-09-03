<template>
  <transition name="modal">
    <div class="modalMask">
      <div class="modalContainer">
        <button class="modalBtn" @click="$emit('close')">X</button>
        <div>
          <img class="star" src="https://upload.wikimedia.org/wikipedia/en/e/e5/Yellow_Star.png" alt="star">
        </div>
        <div class="playerInfo">
          <h3 class="playerName"> Navn: {{ player.name }} </h3>
          <h4> {{ player.correctCount }} - Riktige </h4>
          <h4> {{ player.failCount }} - Feil  </h4>
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
export default {
  props: {
    player: {
      name: {
        type: String,
        default: '',
      },
      correctCount: {
        type: Number,
        default: 0,
      },
      failCount: {
        type: Number,
        default: 0,
      },
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
  background-color: rgba(0, 0, 0, .5);
  display: table;
  transition: opacity .3s ease;
}

.modalContainer {
  display: flex;
  margin: 300px auto 0 auto;
  border-radius: 10px;
  width: 500px;
  height: 200px;
  background-color: rgba(182, 182, 182, 0.616);
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
  height: auto;
  width: 175px;
  padding: 20px;
}

.modalBtn {
  float:right;
  cursor: pointer;
  border: none;
  border-radius: 10px;
  outline:none
}

</style>
