<template>
  <div class="home">
    <h1>Создать ссылку</h1>
    <form @submit.prevent @submit="send">
      <div class="mb-3" v-if=!password_from_query>
        <label for="passwordInput" class="form-label">Код авторизации</label>
        <input
          type="password"
          class="form-control"
          id="passwordInput"
          v-model="password"
          required
        />
      </div>
      <div class="mb-3">
        <label for="urlToInput" class="form-label">Ссылка, которую нужно сократить</label>
        <input
          type="url"
          class="form-control"
          id="urlToInput"
          aria-describedby="urlToHelp"
          placeholder="https://dyakov.space/"
          v-model="url_to"
          required
        />
      </div>
      <div class="mb-3">
        <label for="urlFromInput" class="form-label">Имя ссылки</label>
        <div class="input-group mb-3">
          <span class="input-group-text" id="basic-addon3">{{root}}/</span>
          <input
            type="text"
            class="form-control"
            id="urlFromInput"
            aria-describedby="urlFromHelp"
            placeholder="blog"
            v-model="url_from"
            required
          />
        </div>
      </div>
      <button type="submit" class="btn btn-primary">Сократить</button>
    </form>
    <toast :state="state" :url_from_prev="url_from_prev" @clear="clear"></toast>
  </div>
</template>

<script>
import axios from "axios";
import Toast from "@/components/Toast.vue";


function makeName(length) {
    let result = '';
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    const charactersLength = characters.length;
    let counter = 0;
    while (counter < length) {
      result += characters.charAt(Math.floor(Math.random() * charactersLength));
      counter += 1;
    }
    return result;
}


export default {
  components: {
    Toast,
  },
  data() {
    return {
      url_from: makeName(6),
      url_to: "",
      password: "",
      password_from_query: false,
      state: undefined,
      url_from_prev: undefined,
      root: process.env.VUE_APP_API_ROOT,
    };
  },
  mounted() {
    if (localStorage.password) {
      this.password = localStorage.password;
    }
    console.log(this.$route.query['token']);
    if (this.$route.query['token'] !== undefined) {
      this.password = this.$route.query['token'];
      this.password_from_query = true;
    }
    this.$router.replace({'query': null});
  },
  watch: {
    password(new_password) {
      localStorage.setItem('password', new_password);
    },
  },
  methods: {
    async send() {
      console.log(`Trying to create ${process.env.VUE_APP_API_ROOT}/${this.url_from}`);
      try {
        var response = await axios.post(
          `${process.env.VUE_APP_API_ROOT}/${this.password}/url/${this.url_from}`,
          {
            url_to: this.url_to,
          }
        );
        console.log(response);
        this.appendHistory(this.url_from);
        this.state = "create-ok";
        this.url_from_prev = `${process.env.VUE_APP_API_ROOT}/${this.url_from}`;
        this.url_from = makeName(6);
        this.url_to = "";
      } catch (error) {
        this.state = "create-fail";
      }
      console.log(this.state);
    },
    appendHistory(alias) {
      var hist;
      hist = localStorage.getItem('history') || "[]";
      hist = JSON.parse(hist);
      hist.push(alias)
      localStorage.setItem('history', JSON.stringify(hist))
    },
    clear() {
      console.log("clear");
      this.state = undefined;
      this.url_from_prev = undefined;
      this.url_from = "";
      this.url_to = "";
    },
  },
};
</script>
