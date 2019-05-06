<template>
  <div class="hello">
    <h2>Login</h2>
    <div>
    <label for="email" >Email</label>
    <input class="input-block" type="text" v-model="email">
    </div>
    <div>
    <label for="password" >Password</label>
    <input class="input-block" type="password" v-model="password">
    </div>
    <div>
    <button v-on:click="login">Login</button>
  </div>
  </div>
</template>

<script>
import Vue from 'vue'
import axios from 'axios'
import VueAxios from 'vue-axios'
 
Vue.use(VueAxios, axios)
var loginURL = 'http://api:3000/login'

export default {
  data () {
    return {
      email: "",
      password: "",
    }
  },
  methods: {
    login: function () {
      var formData = JSON.stringify({
        email: this.email,
        password: this.password
      })

      this.axios.post(loginURL, formData).then(response => {
        console.log(response);
        if(response.status == 200){
          this.$parent.$data.loginView = false;
          this.$router.push('requestRide');
        }else{
          alert("Login failed")
          this.$router.push('login');
        }
      })
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
