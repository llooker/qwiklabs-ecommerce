connection: "thelook_bq"

# include all the views
include: "/views/**/*.view"


datagroup: training_ecommerce_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: training_ecommerce_default_datagroup

label: "E-commerce"

datagroup: default_users_datagroup {
  sql_trigger: select current_date ;;
  max_cache_age: "24 hours"
}

datagroup: order_items_datagroup {
  sql_trigger: select max(created_at) from order_items.__TABLE_NAME__  ;;
  max_cache_age: "4 hours"
}

# explore: distribution_centers {}

# explore: events {
#
#   join: users {
#     type: left_outer
#     sql_on: ${events.user_id} = ${users.id} ;;
#     relationship: many_to_one
#   }
# }

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
  persist_with: order_items_datagroup

  sql_always_where: ${returned_date} IS NULL ;;

  #sql_always_having: ${total_sales} > 200 ;;
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;

    relationship: many_to_one
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

datagroup: order_items_dg  {
  sql_trigger: select max(id) from users ;;
  max_cache_age: "4 hours"
}

explore: users {
  persist_with: default_users_datagroup
  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
  join: user_facts {
    type: inner
    sql_on: ${users.id} = ${user_facts.user_id} ;;
    relationship: one_to_one
  }
  join: user_fatcs_ndt {
    type: inner
    sql_on: ${users.id} = ${user_fatcs_ndt.id} ;;
    relationship: one_to_one
  }
}
