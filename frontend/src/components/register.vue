<template>
  <div class="hello">
    <h2>Register</h2>
    <div>
        <label>Email</label>
        <input type="text" class="input-block" v-model="email">
    </div>
    <div>
        <label>Password</label> 
        <input type="password" class="input-block" v-model="password">
    </div>
    <div>
        <label>First Name</label> 
        <input type="text" class="input-block" v-model="firstName">
    </div>
    <div>
        <label>Last Name</label> 
        <input type="text" class="input-block" v-model="lastName">
    </div>
    <div>
        <label>Cell</label> 
        <input type="text" class="input-block" v-model="cell">
    </div>
    <div>
        <label>Department</label> 
        <input type="text" class="input-block" v-model="department">
    </div>
    <div>    
        <label>FullTime</label> 
        <input type="text" class="input-block" v-model="fulltime">
    </div>
    <div>
        <label>Position</label> 
        <input type="text" class="input-block" v-model="position">
    </div>
    
    <div>
        <label>Graduation Year</label> 
        <select v-model="gradYear">
          <option disabled value="">Please select one</option>
          <option>2018</option>
          <option>2019</option>
          <option>2020</option>
          <option>2021</option>
          <option>2022</option>
          <option>2023</option>
          <option>2024</option>
          <option>2025</option>
        </select>
    </div>
    <div>
        <label>Birthdate</label>
        <input type="text" class="input-block" v-model="birthdate">
    </div>
    <button v-on:click="register">Register</button>
  </div>
</template>

<script>
import Vue from 'vue'
import axios from 'axios'
import VueAxios from 'vue-axios'
 
Vue.use(VueAxios, axios)

var registerURL = 'http://api:3000/createUser'

export default {
  data () {
    return {
      email: "",
      password: "",
      firstName: "",
      lastName: "",
      cell: "",
      department: "",
      fulltime: "",
      position: "",
      admin: "N",
      gradYear: "",
      birthdate: "",
    }
  },
  methods: {
    register: function () {
      var formData = {
        email: this.email,
        password: this.password,
        firstName: this.firstName,
        lastName: this.lastName,
        cell: this.cell,
        department: this.department,
        fulltime: this.fulltime,
        position: this.position,
        admin: this.admin,
        gradYear: this.gradYear,
        birthdate: this.birthdate,
      }

      this.axios.post(registerURL, JSON.stringify(formData)).then(response => {
        console.log(response);
        this.$router.push('requestRide');
      });
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
