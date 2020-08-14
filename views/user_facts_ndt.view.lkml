# If necessary, uncomment the line below to include explore_source.


# include: "training_ecommerce.model.lkml"

view: user_fatcs_ndt {
  derived_table: {
    datagroup_trigger: default_users_datagroup
    explore_source: users {
      column: average_lifetime_items { field: user_facts.average_lifetime_items }
      column: id {field: user_facts.user_id}
      column: average_lifetime_orders { field: user_facts.average_lifetime_orders }
      column: average_lifetime_spend { field: user_facts.average_lifetime_spend }
      column: first_order_date { field: user_facts.first_order_date }
      column: latest_order_date { field: user_facts.latest_order_date }
    }
  }
  dimension: average_lifetime_items {
    type: number
  }
  dimension: id {
    type: number
  }
  dimension: average_lifetime_orders {
    type: number
  }
  dimension: average_lifetime_spend {
    type: number
  }
  dimension: first_order_date {
    type: date
  }
  dimension: latest_order_date {
    type: date
  }
}
