module ApplicationHelper
  def user_avatar(user)
    if user.avatar_url.present?
      user.avatar_url
    else
      asset_pack_path 'media/images/avatar.jpg'
    end
  end

  def fa_icon(icon_class)
    content_tag 'span', '', class: "fa fa-#{icon_class}"
  end

  def declination(number, form1, form2, form3)
    last_two_digit = number % 100
    return form3 if last_two_digit.between?(11, 14)

    last_digit = number % 10

    return form1 if last_digit == 1
    return form2 if last_digit.between?(2, 4)
    form3
  end
end
