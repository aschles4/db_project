<template>
  <div id="app">
    <h1>The Back Nines</h1>
    <router-view></router-view>
    <span v-if="loginView">
      <router-link v-bind:to="'/'">Login</router-link> <br/>
      <router-link v-bind:to="'/register'">Register</router-link>
    </span>
  </div>
</template>

<script>

export default {
  name: 'app',
  components: {
  },
  data() {
    return {
      email: "",
      password: "",
      loginView: true,
    }
  },
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
