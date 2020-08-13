view: order_items {
  sql_table_name: `ecomm.order_items`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.shipped_at ;;
  }

  dimension_group: time_to_ship {
    type: duration
    intervals: [day, week, month]
    sql_start: ${shipped_date} ;;
    sql_end: ${delivered_date} ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: total_sales{
    type:sum
        sql: ${sale_price} ;;
        value_format_name: usd
  }

  measure: Avergae_Sales{
    type:average
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: Order_Distinct_Count{
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: Total_Sales_Email_Users {
    type: sum
    sql: ${sale_price};;
    filters: [users.traffic_source:"Email"]
    value_format_name: usd
  }

  measure: Percent_Sales_Email_Users {
    type: number
    sql: 1.00 * ${Total_Sales_Email_Users}/ NULLIF(${total_sales}, 0);;
        value_format_name: percent_2
  }

  measure: average_spend_per_user {
    type: number
    sql:  1.00 * ${total_sales} / NULLIF (${users.count}, 0);;
    value_format_name: usd
  }


      # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.last_name,
      users.id,
      users.first_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
