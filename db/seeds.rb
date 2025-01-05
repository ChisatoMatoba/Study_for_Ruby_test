if User.owner.none?
  User.create!(
    email: ENV['OWNER_EMAIL'],
    password: ENV['OWNER_PASSWORD'],
    name: ENV['OWNER_NAME'],
    role: :owner
  )
end
