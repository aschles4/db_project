<template>
  <div class="hello">
    <h2>Request Ride</h2>
    <div>
        <label>Email</label>
        <input type="text" v-model="email">
    </div>
    <div>
        <label>First Name</label> 
        <input type="text" v-model="firstName">
    </div>
    <div>
        <label>Last Name</label> 
        <input type="text" v-model="lastName">
    </div>
    <div>
        <label>Cell</label> 
        <input type="text" v-model="cell">
    </div>
    <div>
        <label>Start Location</label> 
        <select v-model="startLoc">
          <option disabled value="">Please select one</option>
          <option v-for="loc in locations" v-bind:key="loc.id"> {{loc.name}} </option>
        </select>
    </div>
    <div>
        <label>End Location</label>
        <select v-model="endLoc">
          <option disabled value="">Please select one</option>
          <option v-for="loc in locations" v-bind:key="loc.id"> {{ loc.name }} </option>
        </select>
    </div>
    <div>
        <label>Start Time</label>
        <input type="text" v-model="startTime">
    </div>
    {{getLoc}}
    <button v-on:click="requestRide">Request Ride</button>
  </div>
</template>

<script>
import Vue from 'vue'
import axios from 'axios'
import VueAxios from 'vue-axios'
 
Vue.use(VueAxios, axios)

var createRideURL = 'http://localhost:3000/createRide'

export default {
  data () {
    return {
      email: "",
      firstName: "",
      lastName: "",
      cell: "",
      startLoc: "",
      endLoc: "",
      startTime: 0,  
      locations: [],
    }
  },
  computed: {
    getLoc: function () {
      // `this` points to the vm instance
       this.axios.get('http://localhost:3000/locations').then(response => {
        console.log(response)
        this.locations = response.data.loc
       })
    }
  },
  methods: {
    requestRide: function () {
      var formData = {
        email: this.email,
        firstName: this.firstName,
        lastName: this.lastName,
        startLoc: this.startLoc,
        endLoc: this.endLoc,
        birthdate: this.birthdate,
      }
      this.axios.post(createRideURL, JSON.stringify(formData)).then(response => {
        console.log(response)
        alert("Ride has been requested!!")
      }, response => {
        console.log(response)
      })
    },
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
