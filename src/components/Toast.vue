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
      <strong class="me-auto">Статус</strong>
      <button
        type="button"
        class="btn-close"
        aria-label="Close"
        @click="$emit('clear')"
      ></button>
    </div>
    <div class="toast-body" v-if="state == 'create-ok'">
      Ссылка создана!<br />
      <a
        :href="url_from_prev"
        target="_blank"
        rel="noopener noreferrer"
      >
        {{ url_from_prev }}
      </a>
    </div>
    <div class="toast-body" v-else-if="state == 'create-fail'">
      Не удалось создать ссылку. Короткий адрес уже существует?
    </div>
    <div class="toast-body" v-else-if="state == 'remove-ok'">
      Ссылка <code>{{ url_from_prev }}</code> удалена
    </div>
    <div class="toast-body" v-else-if="state == 'remove-fail'">
      Не удалось удалить ссылку <code>{{ url_from_prev }}</code>. Короткий адрес уже существует?
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
