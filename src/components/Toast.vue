<template>
  <div
    class="toast show"
    id="status-toast"
    role="alert"
    aria-live="assertive"
    aria-atomic="true"
    v-if="state !== undefined"
  >
    <div class="toast-header">
      <strong class="me-auto">Создание короткой ссылки</strong>
      <button
        type="button"
        class="btn-close"
        aria-label="Close"
        @click="$emit('clear')"
      ></button>
    </div>
    <div class="toast-body" v-if="url_from_prev !== undefined">
      Ссылка создана!<br />
      <a
        href="http://{{url_from_prev}}"
        target="_blank"
        rel="noopener noreferrer"
      >
        {{ url_from_prev }}
      </a>
    </div>
    <div class="toast-body" v-else>
      Не удалось создать ссылку. Короткий адрес уже существует?
    </div>
  </div>
</template>


<script>
export default {
  name: "Toast",
  props: {
    state: undefined,
    url_from_prev: undefined,
  },
};
</script>


<style scoped>
#status-toast {
  position: absolute;
  bottom: 10px;
  right: 10px;
}
</style>
