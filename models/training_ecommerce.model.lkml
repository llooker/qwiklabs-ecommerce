connection: "thelook_bq"

# include all the views
include: "/views/**/*.view"

datagroup: training_ecommerce_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: training_ecommerce_default_datagroup

label: "E-commerce"

# explore: distribution_centers {}

# explore: events {
#
#   join: users {
#     type: left_outer
#     sql_on: ${events.user_id} = ${users.id} ;;
#     relationship: many_to_one
#   }
# }

explore:  users {
  join: order_items {
    type:  left_outer
    sql_on:  ${users.id} =${order_items.user_id} ;;
    relationship:  one_to_many
  }
}

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
  ##Day 2 - Exc 1
##  sql_always_where:  ${returned_raw} IS NULL ;;
##  sql_always_having:  ${order_items.sale_price} > 200;;

  ##Day 2 - Exc 2
  sql_always_where:  ${returned_date} IS NULL
  and ${status} = 'Complete';;
  sql_always_having: ${count > 50} ;;

##Day 2 - Exc 3
conditionally_filter: {
  filters: [created_date: "before today"]
  unless: [users.id]
}



  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: products {
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}
