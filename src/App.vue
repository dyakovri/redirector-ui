<template>
  <div id="box" class="container">
    <div id="nav">
      <router-link to="/">Home</router-link> |
      <router-link to="/history">History</router-link> |
      <router-link to="/about">About</router-link>
    </div>
    <router-view />
  </div>
</template>

<style>
#nav {
  margin: 20px auto;

}
</style>
