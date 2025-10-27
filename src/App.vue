<template>
  <div style="font-family: Arial, sans-serif; padding: 20px; max-width: 800px; margin: auto;">
    <h2>Seller Performance Dashboard</h2>

    <div style="margin-bottom:12px;">
      <label>Select seller: </label>
      <select v-model.number="selectedSeller" @change="fetchSummary">
        <option v-for="id in sellerIds" :key="id" :value="id">Seller {{ id }}</option>
      </select>
      <button @click="fetchSummary">Refresh</button>
    </div>

    <div v-if="loading">Loading...</div>
    <div v-if="error" style="color: red">Error: {{ error }}</div>

    <div v-if="summary && !loading" style="border:1px solid #eee; padding:16px; border-radius:8px;">
      <h3>Metrics for Seller {{ summary.sellerId }}</h3>
      <p><strong>Total sales (this week):</strong> {{ summary.totalSalesThisWeek }}</p>
      <p><strong>Total revenue (this week):</strong> {{ formatCurrency(summary.totalRevenueThisWeek) }}</p>
      <p><strong>Return rate:</strong> {{ (summary.returnRate * 100).toFixed(2) }}%</p>

      <div v-if="summary.alerts && summary.alerts.length">
        <h4>Alerts</h4>
        <ul>
          <li v-for="(a,i) in summary.alerts" :key="i">{{ a }}</li>
        </ul>
      </div>
      <div v-else>
        <strong>No alerts</strong>
      </div>

      <div style="margin-top:12px; font-size:12px; color:#666;">(Server caches each seller summary for 30s)</div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      sellerIds: [1,2,3,999],
      selectedSeller: 1,
      loading: false,
      error: null,
      summary: null
    }
  },
  mounted() { this.fetchSummary(); },
  methods: {
    async fetchSummary() {
      this.error = null; this.loading = true; this.summary = null;
      try {
        const res = await fetch(`/api/seller/${this.selectedSeller}/summary`);
        if (!res.ok) {
          const body = await res.json().catch(()=>({}));
          this.error = body.error || `HTTP ${res.status}`;
        } else {
          this.summary = await res.json();
        }
      } catch (e) { this.error = e.message; }
      finally { this.loading = false; }
    },
    formatCurrency(v) {
      return new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR' }).format(v);
    }
  }
}
</script>
