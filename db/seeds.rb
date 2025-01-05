if User.owner.none?
  User.create!(
    email: ENV['OWNER_EMAIL'],
    password: ENV['OWNER_PASSWORD'],
    name: 'まとば',
    role: :owner
  )
end
