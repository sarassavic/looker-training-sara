view: users_key_info {
  derived_table: {
    sql: select users.id, users.first_name, users.last_name,
        case when count(order_items.id) = 1 then '1 Order'
             when count(order_items.id) = 2 then '2 Orders'
             when count(order_items.id) between 3 and 5 then '3-5 Orders'
             when count(order_items.id) between 6 and 9 then '6-9 Orders'
             else '10+ Orders'
             end as CustomerLifetimeOrders
      from users join order_items on (users.id = order_items.user_id)
      group by users.id, users.first_name, users.last_name
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: customer_lifetime_orders {
    type: string
    sql: ${TABLE}.CustomerLifetimeOrders ;;
  }

  set: detail {
    fields: [id, first_name, last_name, customer_lifetime_orders]
  }
}
