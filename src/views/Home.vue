<template>
  <div class="home">
    <h1>Создать ссылку</h1>
    <form @submit.prevent @submit="send">
      <div class="mb-3">
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
        <label for="urlFromInput" class="form-label">Имя ссылки</label>
        <input
          type="text"
          class="form-control"
          id="urlFromInput"
          aria-describedby="urlFromHelp"
          placeholder="blog"
          v-model="url_from"
          required
        />
        <div id="urlFromHelp" class="form-text">
          <p>
            Имя ссылки <code>short</code> будет иметь вид
            <code>https://to.dyakov.space/short</code>
          </p>
        </div>
      </div>
      <div class="mb-3">
        <label for="urlToInput" class="form-label">Ссылка</label>
        <input
          type="url"
          class="form-control"
          id="urlToInput"
          aria-describedby="urlToHelp"
          placeholder="https://dyakov.space/"
          v-model="url_to"
          required
        />
        <div id="urlToHelp" class="form-text">
          <p>
            Переходя по короткой ссылке, пользователь на самом деле перейдет по
            этой
          </p>
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
import { API_ROOT } from "@/constants.js"

export default {
  components: {
    Toast,
  },
  data() {
    return {
      url_from: "",
      url_to: "",
      password: "",
      state: undefined,
      url_from_prev: undefined,
    };
  },
  mounted() {
    if (localStorage.password) {
      this.password = localStorage.password;
    }
  },
  watch: {
    password(new_password) {
      localStorage.setItem('password', new_password);
    },
  },
  methods: {
    async send() {
      console.log(`Trying to create ${API_ROOT}/${this.url_from}`);
      try {
        var response = await axios.post(
          `${API_ROOT}/${this.password}/url/${this.url_from}`,
          {
            url_to: this.url_to,
          }
        );
        console.log(response);
        this.appendHistory(this.url_from);
        this.state = "create-ok";
        this.url_from_prev = `${API_ROOT}/${this.url_from}`;
        this.url_from = "";
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
