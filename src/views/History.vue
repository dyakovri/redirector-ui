<template>
  <div class="hist">
    <h1>История ссылок</h1>
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
    <div v-for="(item, index) in hist" :key="index">
      <a :href="item.url_from" target="_blank" rel="noopener noreferrer">
        {{ item.url_from }}
      </a>
      <button
        type="button"
        class="btn-close"
        aria-label="Close"
        @click="deleteItem(index)"
      ></button>
    </div>
  </div>
  <toast :state="state" :url_from_prev="url_from_prev" @clear="clear"></toast>
</template>

<script>
import axios from "axios";
import Toast from "@/components/Toast.vue";
import { API_ROOT } from "@/constants.js";

export default {
  components: {
    Toast,
  },
  data() {
    return {
      hist: [],
      password: "",
      state: undefined,
      url_from_prev: undefined,
    };
  },
  mounted() {
    this.password = localStorage.getItem("password") || "";

    var hist;
    hist = localStorage.getItem("history") || "[]";
    hist = JSON.parse(hist);
    hist.forEach((alias) =>
      this.hist.push({ alias: alias, url_from: `${API_ROOT}/${alias}` })
    );
    console.log(this.hist);
  },
  watch: {
    password(new_password) {
      localStorage.setItem("password", new_password);
    },
  },
  methods: {
    async deleteItem(index) {
      this.url_from_prev = this.hist[index].url_from;
      try {
        var response = await axios.delete(
          `${API_ROOT}/${this.password}/url/${this.hist[index].alias}`,
          {
            url_to: this.url_to,
          }
        );
        console.log(response);
        this.state = "remove-ok";
        this.hist.splice(index, 1);
        var hist = [];
        this.hist.forEach((item) => hist.push(item.alias));
        localStorage.setItem("history", JSON.stringify(hist));
      } catch (error) {
        this.state = "remove-fail";
      }
      console.log(this.state);
    },
    clear() {
      this.state = undefined;
      this.url_from_prev = undefined;
    },
  },
};
</script>
