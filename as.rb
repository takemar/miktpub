require_relative 'model'

module Plugin::MiktpubModel; module AS

  # Core Types
  BaseObject = Type.new
  Link = Type.new
  Activity = Type.new(BaseObject)
  IntransitiveActivity = Type.new(Activity)
  Collection = Type.new(BaseObject)
  OrderedCollection = Type.new(Collection)
  CollectionPage = Type.new(Collection)
  OrderedCollectionPage = Type.new(OrderedCollection, CollectionPage)

  # Activity Types
  Accept = Type.new(Activity)
  TentativeAccept = Type.new(Accept)
  Add = Type.new(Activity)
  Announce = Type.new(Activity)
  Arrive = Type.new(IntransitiveActivity)
  Create = Type.new(Activity)
  Delete = Type.new(Activity)
  Dislike = Type.new(Activity)
  Flag = Type.new(Activity)
  Follow = Type.new(Activity)
  Ignore = Type.new(Activity)
  Block = Type.new(Ignore)
  Join = Type.new(Activity)
  Leave = Type.new(Activity)
  Like = Type.new(Activity)
  View = Type.new(Activity)
  Listen = Type.new(Activity)
  Read = Type.new(Activity)
  Move = Type.new(Activity)
  Travel = Type.new(IntransitiveActivity)
  Offer = Type.new(Activity)
  Invite = Type.new(Offer)
  Question = Type.new(IntransitiveActivity)
  Reject = Type.new(Activity)
  TentativeReject = Type.new(Reject)
  Remove = Type.new(Activity)
  Undo = Type.new(Activity)
  Update = Type.new(Activity)

  # Actor Types
  Application = Type.new(BaseObject)
  Group = Type.new(BaseObject)
  Person = Type.new(BaseObject)
  Organization = Type.new(BaseObject)
  Service = Type.new(BaseObject)

  # Object Types
  Article = Type.new(BaseObject)
  Relationship = Type.new(BaseObject)
  Document = Type.new(BaseObject)
  Audio = Type.new(Document)
  Image = Type.new(Document)
  Video = Type.new(Document)
  Event = Type.new(BaseObject)
  Note = Type.new(BaseObject)
  Page = Type.new(BaseObject)
  Profile = Type.new(BaseObject)
  Place = Type.new(BaseObject)
  Tombstone = Type.new(BaseObject)

  # Link Type
  Mention = Type.new(Link)

  # Properties
  Activity.field.has :actor, [Model[BaseObject], Model[Link]]
  BaseObject.field.has :attachment, [Model[BaseObject], Model[Link]]
  BaseObject.field.has :attributed_to, [Model[BaseObject], Model[Link]]
  Link.field.has :attributed_to, [Model[BaseObject], Model[Link]]
  BaseObject.field.has :audience, [Model[BaseObject], Model[Link]]
  BaseObject.field.has :bcc, [Model[BaseObject], Model[Link]]
  BaseObject.field.has :bto, [Model[BaseObject], Model[Link]]
  BaseObject.field.has :cc, [Model[BaseObject], Model[Link]]
  BaseObject.field.has :context, [Model[BaseObject], Model[Link]]
  Collection.field.has :current, [Model[CollectionPage], Model[Link]]
  Collection.field.has :first, [Model[CollectionPage], Model[Link]]
  BaseObject.field.has :generator, [Model[BaseObject], Model[Link]]
  BaseObject.field.has :icon, [Model[Image], Model[Link]]
  BaseObject.field.has :image, [Model[Image], Model[Link]]
  BaseObject.field.has :in_reply_to, [Model[BaseObject], Model[Link]]
  Activity.field.has :instrument, [Model[BaseObject], Model[Link]]
  Collection.field.has :last, [Model[CollectionPage], Model[Link]]
  BaseObject.field.has :location, [Model[BaseObject], Model[Link]]
  Collection.field.has :items, [[Model[BaseObject], Model[Link]]]
  Question.field.has :one_of, [Model[BaseObject], Model[Link]]
  Question.field.has :any_of, [Model[BaseObject], Model[Link]]
  Question.field.has :closed, [Model[BaseObject], Model[Link], :time, :bool]
  Activity.field.has :origin, [Model[BaseObject], Model[Link]]
  CollectionPage.field.has :next, [Model[CollectionPage], Model[Link]]
  Activity.field.has :object, [Model[BaseObject], Model[Link]]
  IntransitiveActivity.field.has :object, :null
  Relationship.field.has :object, [Model[BaseObject], Model[Link]]
  CollectionPage.field.has :prev, [Model[CollectionPage], Model[Link]]
  BaseObject.field.has :preview, [Model[BaseObject], Model[Link]]
  Link.field.has :preview, [Model[BaseObject], Model[Link]]
  Activity.field.has :result, [Model[BaseObject], Model[Link]]
  BaseObject.field.has :replies, [[Model[BaseObject], Model[Link]]]
  BaseObject.field.has :tag, [Model[BaseObject], Model[Link]]
  Activity.field.has :target, [Model[BaseObject], Model[Link]]
  BaseObject.field.has :to, [Model[BaseObject], Model[Link]]
  BaseObject.field.has :url, [:uri, Model[Link]]
  Place.field.float :accuracy
  Place.field.float :altitude
  BaseObject.field.string :content 
  BaseObject.field.string :name
  Link.field.string :name
  BaseObject.field.string :duration # TODO: more precise definition
  Link.field.int :height
  Link.field.uri :href
  Link.field.string :hreflang # TODO: more precise definition
  CollectionPage.field.has :part_of, [Model[Collection], Model[Link]]
  Place.field.float :latitude
  Place.field.float :longitude
  BaseObject.field.string :media_type
  Link.field.string :media_type
  BaseObject.field.time :end_time
  BaseObject.field.time :published
  BaseObject.field.time :start_time
  Place.field.float :radius
  Link.field.string :rel
  OrderedCollectionPage.field.int :start_index
  BaseObject.field.string :summary
  Collection.field.int :total_items
  Place.field.has :units, [:string, :uri]
  BaseObject.field.time :updated
  Link.field.int :width
  Relationship.field.has :subject, [Model[BaseObject], Model[Link]]
  Relationship.field.has :relationship, [Model[BaseObject], :uri, :string]
  Profile.field.has :describes, Model[BaseObject]
  Tombstone.field.has :former_type, Model[BaseObject]
  Tombstone.field.time :deleted

end; end
